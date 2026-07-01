#!/usr/bin/env bash
#
# provision.sh — interactively pick a container engine, generate the playbook,
# and apply it with ansible-playbook.
#
# This script is the source of truth for the top-level playbook (there is no
# committed site.yml). It writes a temporary playbook listing every role plus
# the chosen container engine, then hands it to ansible-playbook.
#
# Required Galaxy collections (requirements.yml) are installed automatically
# before the playbook runs; skip that step with --skip-galaxy.
#
# GUI applications (a windowed app rather than a CLI tool — currently just the
# Ghostty terminal emulator) can be skipped, which is handy on a headless or
# remote workstation. Pass --skip-gui, or answer the interactive prompt.
#
# Claude Code can likewise be skipped (no account, policy reasons, slimmer box).
# Pass --skip-claude, or answer the interactive prompt.
#
# Picked variables (the container engine and whether to install GUI apps /
# Claude Code) are remembered in a local state file (.provision.env,
# git-ignored), so later runs reuse them without prompting. Force a fresh pick
# with --reconfigure.
#
# Any extra arguments are forwarded to ansible-playbook, e.g.:
#   ./provision.sh -K --check --diff
#
# Non-interactive overrides (each takes precedence over saved state and the
# interactive prompt):
#   CONTAINER_ENGINE=docker|podman   pick the container engine
#   INSTALL_GUI=1|0 (yes/no)         install or skip GUI applications
#   INSTALL_CLAUDE=1|0 (yes/no)      install or skip Claude Code

# Re-exec under bash if started with another shell (e.g. `zsh provision.sh`):
# the interactive menu relies on bash's single-key `read -rsn1`.
if [ -z "${BASH_VERSION:-}" ]; then
	exec bash "$0" "$@"
fi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Persisted picks from previous runs (sourced as KEY=value shell assignments).
STATE_FILE="${SCRIPT_DIR}/.provision.env"

# Galaxy collections the playbook depends on (e.g. community.general, which
# provides homebrew/homebrew_cask/pipx/git_config used across the roles).
REQUIREMENTS="${SCRIPT_DIR}/requirements.yml"

# Roles applied to every workstation, in a readable top-to-bottom order. The
# finer ordering is enforced by each role's meta/main.yml `dependencies`
# (homebrew, zsh_config, …), so this list only needs to be roughly sensible.
# The container engine (docker | podman) is appended at runtime — keep it out
# of this list.
COMMON_ROLES=(
	homebrew
	zsh
	oh_my_zsh
	zsh_config
	powerlevel10k
	zsh_autosuggestions
	zsh_syntax_highlighting
	oh_my_zsh_plugins
	autoswitch_virtualenv
	nerd_fonts
	git_config
	neovim
	htop
	pre_commit
	shellcheck
	shfmt
	hadolint
	dockerfmt
	dockle
	trivy
	gitleaks
	editorconfig_checker
	yamlfmt
	yamllint
	nvm
	node
	pyenv
	python
	golang
	golangci_lint
	goreleaser
	just
	terraform
	helm
	gcloud
	glab
	plantuml
)

# GUI applications: roles that install a windowed app (a .app on macOS, a
# desktop entry on Linux) rather than a CLI tool. Kept separate from
# COMMON_ROLES so a headless or remote workstation can skip them — they are
# appended to the playbook only when GUI installation is enabled (see the
# --skip-gui / INSTALL_GUI / interactive prompt logic below). Like the
# container engine, keep these out of COMMON_ROLES.
GUI_ROLES=(
	ghostty
)

# Claude Code: kept separate from COMMON_ROLES so it can be skipped on machines
# where it isn't wanted (no account, policy reasons, slimmer box). It is
# appended to the playbook only when Claude installation is enabled (see the
# --skip-claude / INSTALL_CLAUDE / interactive prompt logic below). Like the
# container engine and GUI roles, keep this out of COMMON_ROLES.
CLAUDE_ROLES=(
	claude_code
)

# --- Colors (disabled when not a TTY or NO_COLOR is set) ----------------------
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
	BOLD=$'\033[1m'
	DIM=$'\033[2m'
	CYAN=$'\033[36m'
	GREEN=$'\033[32m'
	YELLOW=$'\033[33m'
	RED=$'\033[31m'
	RESET=$'\033[0m'
else
	BOLD=''
	DIM=''
	CYAN=''
	GREEN=''
	YELLOW=''
	RED=''
	RESET=''
fi

info() { printf '%s==>%s %s\n' "${GREEN}${BOLD}" "${RESET}" "$*"; }
warn() { printf '%s==>%s %s\n' "${YELLOW}${BOLD}" "${RESET}" "$*" >&2; }
die() {
	printf '%serror:%s %s\n' "${RED}${BOLD}" "${RESET}" "$*" >&2
	exit 1
}

# --- Numbered menu ------------------------------------------------------------
# Usage: menu "Question" "Option A" "Option B" ...; result index in $MENU_CHOICE.
# Uses a plain line-read (no raw mode / cursor escapes), so it behaves the same
# in every terminal and shell.
MENU_CHOICE=0
menu() {
	local prompt="$1"
	shift
	local options=("$@")
	local count=${#options[@]}
	local i choice

	# Non-interactive (piped stdin): pick the first option.
	if [[ ! -t 0 ]]; then
		MENU_CHOICE=0
		return
	fi

	printf '%s%s%s\n' "${BOLD}" "$prompt" "${RESET}"
	for i in "${!options[@]}"; do
		printf '  %s%d)%s %s\n' "${CYAN}${BOLD}" "$((i + 1))" "${RESET}" "${options[i]}"
	done

	while true; do
		printf '%s➜ choose [1-%d] (default 1):%s ' "${BOLD}" "$count" "${RESET}"
		read -r choice || {
			choice=1
			break
		}
		choice="${choice:-1}"
		if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= count)); then
			break
		fi
		warn "Please enter a number between 1 and ${count}."
	done
	MENU_CHOICE=$((choice - 1))
}

# --- Playbook generation ------------------------------------------------------
# Usage: generate_playbook <engine> <output-file>
# Writes the full top-level playbook: every common role, the GUI roles (unless
# the user opted out via $install_gui), then the chosen container engine.
generate_playbook() {
	local engine="$1" out="$2" role
	local roles=("${COMMON_ROLES[@]}")
	if [[ "$install_gui" -eq 1 ]]; then
		roles+=("${GUI_ROLES[@]}")
	fi
	if [[ "$install_claude" -eq 1 ]]; then
		roles+=("${CLAUDE_ROLES[@]}")
	fi
	roles+=("$engine")
	{
		printf -- '---\n'
		printf '# Generated by provision.sh — do not edit by hand.\n'
		printf '# Container engine: %s\n' "$engine"
		printf '# GUI applications: %s\n' "$([[ "$install_gui" -eq 1 ]] && echo installed || echo skipped)"
		printf '# Claude Code: %s\n' "$([[ "$install_claude" -eq 1 ]] && echo installed || echo skipped)"
		printf -- '- name: Configure work environment\n'
		printf '  hosts: workstations\n'
		printf '  gather_facts: true\n'
		printf '  roles:\n'
		for role in "${roles[@]}"; do
			printf '    - %s\n' "$role"
		done
	} >"$out"
}

# --- State --------------------------------------------------------------------
# Persist the picked variables so the next run can reuse them. The file is a
# plain list of KEY=value assignments, sourced on the next run.
save_state() {
	umask 077
	{
		printf '# Generated by provision.sh — remembered picks. Safe to delete.\n'
		printf 'CONTAINER_ENGINE=%s\n' "$engine"
		printf 'INSTALL_GUI=%s\n' "$install_gui"
		printf 'INSTALL_CLAUDE=%s\n' "$install_claude"
	} >"$STATE_FILE"
}

# --- Sanity checks ------------------------------------------------------------
command -v ansible-playbook >/dev/null 2>&1 \
	|| die "ansible-playbook not found. Install Ansible first."

printf '\n%s%s  workenv provisioner%s\n\n' "${BOLD}" "${CYAN}" "${RESET}"

# --- Parse our own flags (everything else is forwarded to ansible-playbook) ---
reconfigure=0
skip_galaxy=0
skip_gui=0
skip_claude=0
PLAYBOOK_ARGS=()
for arg in "$@"; do
	case "$arg" in
		--reconfigure) reconfigure=1 ;;
		--skip-galaxy) skip_galaxy=1 ;;
		--skip-gui) skip_gui=1 ;;
		--skip-claude) skip_claude=1 ;;
		*) PLAYBOOK_ARGS+=("$arg") ;;
	esac
done

# Capture the env-var overrides before anything sources the state file, so a
# stale state file can't clobber an explicit env var.
engine="${CONTAINER_ENGINE:-}"
install_gui_env="${INSTALL_GUI:-}"
install_claude_env="${INSTALL_CLAUDE:-}"

# --- Pick the container engine ------------------------------------------------
# Precedence: CONTAINER_ENGINE env var > saved state > interactive prompt.

if [[ -z "$engine" && "$reconfigure" -eq 0 && -f "$STATE_FILE" ]]; then
	# shellcheck source=/dev/null
	source "$STATE_FILE"
	engine="${CONTAINER_ENGINE:-}"
	[[ -n "$engine" ]] && info "Reusing saved container engine (--reconfigure to change)."
fi

if [[ -z "$engine" ]]; then
	menu "Which container engine do you want to use?" \
		"Docker  — Docker Engine / Desktop" \
		"Podman  — daemonless, rootless-friendly"
	case "$MENU_CHOICE" in
		0) engine="docker" ;;
		1) engine="podman" ;;
	esac
fi

case "$engine" in
	docker | podman) ;;
	*) die "Invalid CONTAINER_ENGINE='${engine}' (expected docker or podman)" ;;
esac
info "Container engine: ${BOLD}${engine}${RESET}"

# --- Pick whether to install GUI applications ---------------------------------
# GUI_ROLES install windowed apps that are pointless on a headless or remote
# box. Precedence mirrors the container engine, with an extra explicit flag:
#   --skip-gui > INSTALL_GUI env var > saved state > interactive prompt (yes).
install_gui=""

if [[ "$skip_gui" -eq 1 ]]; then
	install_gui=0
elif [[ -n "$install_gui_env" ]]; then
	case "${install_gui_env,,}" in
		1 | y | yes | true | on) install_gui=1 ;;
		0 | n | no | false | off) install_gui=0 ;;
		*) die "Invalid INSTALL_GUI='${install_gui_env}' (expected 1/0, yes/no, true/false)" ;;
	esac
fi

# Fall back to the remembered pick (unless --reconfigure) before prompting.
if [[ -z "$install_gui" && "$reconfigure" -eq 0 && -f "$STATE_FILE" ]]; then
	# shellcheck source=/dev/null
	source "$STATE_FILE"
	install_gui="${INSTALL_GUI:-}"
	[[ -n "$install_gui" ]] && info "Reusing saved GUI choice (--reconfigure to change)."
fi

if [[ -z "$install_gui" ]]; then
	menu "Install GUI applications (Ghostty terminal)?" \
		"Yes — install GUI apps" \
		"No  — skip GUI apps (headless / remote box)"
	case "$MENU_CHOICE" in
		0) install_gui=1 ;;
		1) install_gui=0 ;;
	esac
fi

case "$install_gui" in
	0 | 1) ;;
	*) die "Invalid INSTALL_GUI='${install_gui}' (expected 1 or 0)" ;;
esac
info "GUI applications: ${BOLD}$([[ "$install_gui" -eq 1 ]] && echo install || echo skip)${RESET}"

# --- Pick whether to install Claude Code --------------------------------------
# CLAUDE_ROLES install Claude Code, which isn't wanted on every box. Precedence
# mirrors the GUI choice:
#   --skip-claude > INSTALL_CLAUDE env var > saved state > interactive prompt (yes).
install_claude=""

if [[ "$skip_claude" -eq 1 ]]; then
	install_claude=0
elif [[ -n "$install_claude_env" ]]; then
	case "${install_claude_env,,}" in
		1 | y | yes | true | on) install_claude=1 ;;
		0 | n | no | false | off) install_claude=0 ;;
		*) die "Invalid INSTALL_CLAUDE='${install_claude_env}' (expected 1/0, yes/no, true/false)" ;;
	esac
fi

# Fall back to the remembered pick (unless --reconfigure) before prompting.
if [[ -z "$install_claude" && "$reconfigure" -eq 0 && -f "$STATE_FILE" ]]; then
	# shellcheck source=/dev/null
	source "$STATE_FILE"
	install_claude="${INSTALL_CLAUDE:-}"
	[[ -n "$install_claude" ]] && info "Reusing saved Claude Code choice (--reconfigure to change)."
fi

if [[ -z "$install_claude" ]]; then
	menu "Install Claude Code?" \
		"Yes — install Claude Code" \
		"No  — skip Claude Code"
	case "$MENU_CHOICE" in
		0) install_claude=1 ;;
		1) install_claude=0 ;;
	esac
fi

case "$install_claude" in
	0 | 1) ;;
	*) die "Invalid INSTALL_CLAUDE='${install_claude}' (expected 1 or 0)" ;;
esac
info "Claude Code: ${BOLD}$([[ "$install_claude" -eq 1 ]] && echo install || echo skip)${RESET}"

# Remember the picks for next time.
save_state
info "Saved picks to ${DIM}${STATE_FILE}${RESET}"

# --- Generate the temporary playbook ------------------------------------------
TMP_PLAYBOOK="$(mktemp -t workenv-site.XXXXXX)"
mv "$TMP_PLAYBOOK" "${TMP_PLAYBOOK}.yml"
TMP_PLAYBOOK="${TMP_PLAYBOOK}.yml"
trap 'rm -f "$TMP_PLAYBOOK"' EXIT

generate_playbook "$engine" "$TMP_PLAYBOOK"
info "Generated playbook: ${DIM}${TMP_PLAYBOOK}${RESET}"

# --- Install Galaxy dependencies ----------------------------------------------
# The roles reference modules from community.general (homebrew, homebrew_cask,
# pipx, git_config). Ansible resolves a task's module *before* evaluating its
# `when:`, so the collection must be present on every platform — even where the
# homebrew tasks are skipped. Install it up front to avoid "couldn't resolve
# module/action" errors.
if [[ "$skip_galaxy" -eq 0 ]]; then
	if [[ -f "$REQUIREMENTS" ]]; then
		command -v ansible-galaxy >/dev/null 2>&1 \
			|| die "ansible-galaxy not found. Install Ansible first, or pass --skip-galaxy."
		info "Installing Galaxy collections from ${DIM}${REQUIREMENTS}${RESET}"
		ansible-galaxy collection install -r "$REQUIREMENTS"
	else
		warn "No requirements.yml at ${REQUIREMENTS}; skipping Galaxy install."
	fi
else
	info "Skipping Galaxy collection install (--skip-galaxy)."
fi

# --- Apply --------------------------------------------------------------------
cd "$SCRIPT_DIR"
export ANSIBLE_ROLES_PATH="${SCRIPT_DIR}/roles"
info "Applying playbook…"
# Not exec'd, so the EXIT trap can clean up the temporary playbook.
# ${PLAYBOOK_ARGS[@]+...} guards against an empty array under `set -u`.
ansible-playbook -i "${SCRIPT_DIR}/inventory/hosts.yml" "$TMP_PLAYBOOK" \
	${PLAYBOOK_ARGS[@]+"${PLAYBOOK_ARGS[@]}"}
