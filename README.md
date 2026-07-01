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
│   └── hosts.yml        # Managed hosts
├── group_vars/
│   └── all.yml          # Variables for all hosts
├── host_vars/           # Per-host variables
└── roles/               # One role per tool / piece of configuration
```

There is no committed `site.yml`: `provision.sh` is the source of truth for the
top-level playbook. It lets you pick a container engine (Docker or Podman),
writes a temporary playbook listing every role plus that engine, and applies it.

## Usage

```sh
# Install dependencies (if any)
ansible-galaxy install -r requirements.yml

# Interactively pick a container engine, then dry-run against the local machine
./provision.sh --check --diff

# Apply
./provision.sh

# Skip the prompt by pinning the engine
CONTAINER_ENGINE=podman ./provision.sh
```

Extra arguments are forwarded to `ansible-playbook`.
