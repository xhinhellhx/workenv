# Work environments configurations

This repository contains my work environments configurations and shared
scripts, managed as Ansible playbooks.

## Layout

```
.
├── ansible.cfg          # Ansible configuration
├── site.yml             # Top-level playbook
├── requirements.yml     # Galaxy roles/collections
├── inventory/
│   └── hosts.yml        # Managed hosts
├── group_vars/
│   └── all.yml          # Variables for all hosts
├── host_vars/           # Per-host variables
└── roles/
    └── neovim/          # Deploys Neovim configuration
```

## Usage

```sh
# Install dependencies (if any)
ansible-galaxy install -r requirements.yml

# Dry run against the local machine
ansible-playbook site.yml --check --diff

# Apply
ansible-playbook site.yml
```
