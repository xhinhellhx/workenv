from __future__ import annotations

import re

from ansible.plugins.become.sudo import BecomeModule as SudoBecomeModule


DOCUMENTATION = """
    name: sudo_pam
    short_description: sudo become with PAM prompt detection
    description:
        - Extends Ansible's built-in sudo become plugin.
        - Some sudo/PAM combinations ignore sudo's C(-p) prompt unless sudoers
          enables C(passprompt_override). Ansible's local connection waits for
          the configured prompt before writing the become password, so those
          PAM prompts can otherwise cause a timeout.
        - This plugin accepts both Ansible's generated sudo prompt and common
          PAM-provided sudo password prompts.
    author: workenv
    version_added: "2.8"
    options:
        become_user:
            description: User you 'become' to execute the task
            default: root
            ini:
              - section: privilege_escalation
                key: become_user
              - section: sudo_become_plugin
                key: user
            vars:
              - name: ansible_become_user
              - name: ansible_sudo_user
            env:
              - name: ANSIBLE_BECOME_USER
              - name: ANSIBLE_SUDO_USER
            keyword:
              - name: become_user
        become_exe:
            description: Sudo executable
            default: sudo
            ini:
              - section: privilege_escalation
                key: become_exe
              - section: sudo_become_plugin
                key: executable
            vars:
              - name: ansible_become_exe
              - name: ansible_sudo_exe
            env:
              - name: ANSIBLE_BECOME_EXE
              - name: ANSIBLE_SUDO_EXE
            keyword:
              - name: become_exe
        become_flags:
            description: Options to pass to sudo
            default: -H -S -n
            ini:
              - section: privilege_escalation
                key: become_flags
              - section: sudo_become_plugin
                key: flags
            vars:
              - name: ansible_become_flags
              - name: ansible_sudo_flags
            env:
              - name: ANSIBLE_BECOME_FLAGS
              - name: ANSIBLE_SUDO_FLAGS
            keyword:
              - name: become_flags
        become_pass:
            description: Password to pass to sudo
            required: False
            vars:
              - name: ansible_become_password
              - name: ansible_become_pass
              - name: ansible_sudo_pass
            env:
              - name: ANSIBLE_BECOME_PASS
              - name: ANSIBLE_SUDO_PASS
            ini:
              - section: sudo_become_plugin
                key: password
        sudo_chdir:
            description: Directory to change to before invoking sudo; can avoid permission errors when dropping privileges.
            type: string
            required: False
            version_added: '2.19'
            vars:
              - name: ansible_sudo_chdir
            env:
              - name: ANSIBLE_SUDO_CHDIR
            ini:
              - section: sudo_become_plugin
                key: chdir
"""


class BecomeModule(SudoBecomeModule):
    name = "sudo_pam"

    _pam_prompt = re.compile(
        rb"(?i)(?:^\s*(?:\[sudo\]\s*)?)?password(?:\s+for\s+[^:\r\n]+)?[: ]*\s*$"
    )

    def check_password_prompt(self, b_output: bytes) -> bool:
        if super().check_password_prompt(b_output):
            return True

        return any(self._pam_prompt.search(line) for line in b_output.splitlines())

    def strip_become_prompt(self, data: bytes) -> bytes:
        data = super().strip_become_prompt(data)
        return self._pam_prompt.sub(b"", data, count=1)
