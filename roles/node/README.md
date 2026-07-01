# node role

Installs the latest **LTS** Node.js using [nvm](../nvm) and sets it as the
default. Depends on the `nvm` role, which installs nvm first.

## Behaviour

Sources `nvm.sh` in a bash shell and runs:

```sh
nvm install --lts        # install the latest LTS release
nvm alias default 'lts/*' # make LTS the default for new shells
```

Idempotent: re-runs report *ok* (nvm reports "is already installed" when the
current LTS is present).

> Because nvm is a shell function (not a binary), the role runs the commands
> inside `/bin/bash` with `NVM_DIR` exported.
