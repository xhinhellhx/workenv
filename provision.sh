#!/usr/bin/env bash
#
# provision.sh — interactively pick a container engine, generate a temporary
# playbook from site.yml, and apply it with ansible-playbook.
#
# Any extra arguments are forwarded to ansible-playbook, e.g.:
#   ./provision.sh -K --check --diff
#
# Non-interactive override: set CONTAINER_ENGINE=docker|podman to skip the menu.

# Re-exec under bash if started with another shell (e.g. `zsh provision.sh`):
# the interactive menu relies on bash's single-key `read -rsn1`.
if [ -z "${BASH_VERSION:-}" ]; then
	exec bash "$0" "$@"
fi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK="${SCRIPT_DIR}/site.yml"

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

# --- Sanity checks ------------------------------------------------------------
command -v ansible-playbook >/dev/null 2>&1 \
	|| die "ansible-playbook not found. Install Ansible first."
[[ -f "$PLAYBOOK" ]] || die "site.yml not found at ${PLAYBOOK}"

printf '\n%s%s  workenv provisioner%s\n\n' "${BOLD}" "${CYAN}" "${RESET}"

# --- Pick the container engine ------------------------------------------------
engine="${CONTAINER_ENGINE:-}"
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

# --- Generate the temporary playbook ------------------------------------------
TMP_PLAYBOOK="$(mktemp -t workenv-site.XXXXXX)"
mv "$TMP_PLAYBOOK" "${TMP_PLAYBOOK}.yml"
TMP_PLAYBOOK="${TMP_PLAYBOOK}.yml"
trap 'rm -f "$TMP_PLAYBOOK"' EXIT

if [[ "$engine" == "podman" ]]; then
	# Replace the active `- docker` role line with `- podman`.
	sed -E 's/^([[:space:]]*)- docker([[:space:]].*)?$/\1- podman/' \
		"$PLAYBOOK" >"$TMP_PLAYBOOK"
else
	cp "$PLAYBOOK" "$TMP_PLAYBOOK"
fi
info "Generated playbook: ${DIM}${TMP_PLAYBOOK}${RESET}"

# --- Apply --------------------------------------------------------------------
cd "$SCRIPT_DIR"
export ANSIBLE_ROLES_PATH="${SCRIPT_DIR}/roles"
info "Applying playbook…"
# Not exec'd, so the EXIT trap can clean up the temporary playbook.
ansible-playbook -i "${SCRIPT_DIR}/inventory/hosts.yml" "$TMP_PLAYBOOK" "$@"
