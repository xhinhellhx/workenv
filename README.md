# Work environments configurations

This repository contains my work environments configurations and shared
scripts, managed as Ansible playbooks.

## Layout

```
.
├── ansible.cfg          # Ansible configuration
├── provision.sh         # Generates and applies the top-level playbook
├── requirements.yml     # Galaxy roles/collections
├── inventory/
│   ├── hosts.yml        # Managed hosts
│   ├── group_vars/
│   │   └── all.yml      # Variables for all hosts
│   └── host_vars/       # Per-host variables
└── roles/               # One role per tool / piece of configuration
```

There is no committed `site.yml`: `provision.sh` is the source of truth for the
top-level playbook. It lets you pick a container engine (Docker or Podman) and
whether to install GUI applications (the Ghostty terminal — handy to skip on a
headless or remote box), writes a temporary playbook listing every selected
role plus that engine, and applies it. `group_vars`/`host_vars` live next to the
inventory so they load regardless of where that generated playbook sits.

## Usage

`provision.sh` installs the required Galaxy collections (`requirements.yml`)
itself, so there's no separate setup step.

```sh
# Interactively pick a container engine, then dry-run against the local machine
./provision.sh --check --diff

# Apply
./provision.sh

# Skip the prompts by pinning the engine and GUI choice
CONTAINER_ENGINE=podman INSTALL_GUI=no ./provision.sh

# Skip installing GUI applications (e.g. on a headless / remote box)
./provision.sh --skip-gui

# Change a remembered pick
./provision.sh --reconfigure

# Reuse already-installed collections (skip the Galaxy step)
./provision.sh --skip-galaxy
```

Your picks are remembered in `.provision.env` (git-ignored), so later runs skip
the prompts. Precedence for the engine is `CONTAINER_ENGINE` env var > saved
state > prompt; for GUI apps it is `--skip-gui` > `INSTALL_GUI` env var > saved
state > prompt. Any other arguments are forwarded to `ansible-playbook`.
