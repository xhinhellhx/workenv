# terraform role

Installs [Terraform](https://www.terraform.io) **from source** with
`go install github.com/hashicorp/terraform@<version>`. Depends on the `golang`
role (provides the Go toolchain).

The binary is built into `~/go/bin/terraform`. Idempotent: `go install` runs only
when the binary is absent (or `terraform_force: true`).

## Variables

| Variable             | Default                        | Description                              |
| -------------------- | ------------------------------ | ---------------------------------------- |
| `terraform_version`  | `latest`                       | Module query: `latest` or a tag (`v1.9.8`). |
| `terraform_module`   | `github.com/hashicorp/terraform` | Go module path.                        |
| `terraform_gobin`    | `~/go/bin`                     | Install directory (`GOBIN`).             |
| `terraform_force`    | `false`                        | Re-run `go install` regardless.          |

> Ensure `~/go/bin` is on `PATH`. On Linux the `golang` role's profile adds it;
> on macOS add it yourself if needed.
