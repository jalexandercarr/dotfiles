# Development

## Repository Layout

```
home/               # chezmoi source — maps to ~/
  dot_*.tmpl        # Templated config files
  dot_*             # Static config files
  run_once_*        # Scripts that run once
  run_onchange_*    # Scripts that re-run when content changes
  dot_claude/       # Claude Code config
  dot_config/       # XDG config files (nvim, ccstatusline)
  dot_local/bin/    # Installed CLI tools
build/              # Dockerfiles for Ubuntu and Amazon Linux
test/               # chezmoi-test.sh (integration), shellcheck.sh, hooks-test.sh, ghcr-cleanup-test.sh
docs/               # Documentation
```

## Testing

The `build/` directory contains Dockerfiles and a `Makefile` for testing against Ubuntu and Amazon Linux containers. Multi-arch builds (linux/amd64, linux/arm64) are supported via Docker Buildx.

```sh
make build           # Build all Docker images
make test            # Run install tests on all containers
make test-ubuntu     # Ubuntu only
make test-amazon     # Amazon Linux only
make shellcheck      # Lint shell scripts and rendered chezmoi templates
make test-hooks      # Run Claude Code safety hook tests (host, no container)
make test-ghcr-cleanup # Test the GHCR cleanup keep/delete rules (fixtures, no network)
make manual-test     # Interactive container for manual testing
```

Pass `--skip-packages` to the test script for faster dotfiles-only checks:

```sh
./test/chezmoi-test.sh --skip-packages
```

## CI Images

CI builds push images to GHCR tagged `ci-<run_id>` (or `dev-ci-<run_id>`), and only pushes to `main` and releases promote them to `:latest` or a version tag. The weekly **GHCR Cleanup** workflow (`.github/workflows/ghcr-cleanup.yaml`) deletes CI-only versions older than 7 days, plus untagged per-platform manifests no kept image references. Any version that also carries a release or `latest` tag is kept.

`GHCR_TOKEN` needs the `read:packages` and `delete:packages` scopes. Trigger the workflow manually (it defaults to a dry run) to review what would be deleted.

## Useful chezmoi Commands

```sh
chezmoi diff               # Preview what would change
chezmoi apply              # Apply changes
chezmoi edit ~/.bashrc     # Edit a managed file
chezmoi add ~/.config/foo  # Track a new file
chezmoi data               # View current template variables
chezmoi edit-config        # Edit ~/.config/chezmoi/chezmoi.yaml

# Force re-run of all install scripts
chezmoi state delete-bucket --bucket=scriptState && chezmoi apply
```
