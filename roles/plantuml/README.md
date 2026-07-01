# plantuml role

Installs [PlantUML](https://plantuml.com).

| Platform        | Method                                                              |
| --------------- | ------------------------------------------------------------------- |
| macOS           | Homebrew (`plantuml`; pulls OpenJDK + Graphviz)                      |
| Debian / Ubuntu | `apt` Java + Graphviz, fetch the JAR, install a wrapper script      |
| RHEL family     | `dnf` Java + Graphviz, fetch the JAR, install a wrapper script      |

On Linux the JAR is placed in `{{ plantuml_install_dir }}` and a `plantuml`
wrapper (`java -jar …`) is installed to `{{ plantuml_bin }}`.

## Variables

| Variable               | Default                | Description                          |
| ---------------------- | ---------------------- | ------------------------------------ |
| `plantuml_version`     | `1.2026.6`             | PlantUML release (Linux).            |
| `plantuml_install_dir` | `/opt/plantuml`        | JAR location (Linux).                |
| `plantuml_bin`         | `/usr/local/bin/plantuml` | Wrapper script path (Linux).      |

> Graphviz (`dot`) is required for most non-sequence diagrams. On older RHEL it
> may live in EPEL — enable EPEL first if `dnf` can't find it.
