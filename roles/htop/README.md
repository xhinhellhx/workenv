# htop role

Installs the [htop](https://htop.dev) interactive process viewer.

| Platform        | Install            |
| --------------- | ------------------ |
| macOS           | Homebrew (`htop`)  |
| Debian / Ubuntu | `apt install htop` |
| RHEL family     | `dnf install htop` |

Homebrew is ensured by the `homebrew` role dependency. On the RHEL family
`htop` is provided by EPEL on older releases — enable EPEL first if it's not
already available (see the `ghostty`/`neovim` roles for the EPEL pattern).
