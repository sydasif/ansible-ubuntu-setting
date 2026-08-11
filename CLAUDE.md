# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Single-machine Ansible playbook (`local.yml`) that provisions an Ubuntu desktop — packages, dotfiles, Docker, Containerlab, Vagrant/libvirt, GNOME/dconf. Runs against localhost (`--ask-become-pass`), dynamic inventory via `scripts/inventory.py`.

## Commands

```bash
# Full provision (prompts for sudo password)
ansible-playbook local.yml --ask-become-pass

# Single role by tag
ansible-playbook local.yml --tags docker --ask-become-pass

# Lint / validate
yamllint ./
ansible-lint
ansible-playbook local.yml --syntax-check
```

## Architecture

- **Entry point:** `local.yml` — single play, `become: true`, hosts `all` (resolved by `scripts/inventory.py` to the local machine as its distro group, e.g. `Ubuntu`)
- **Roles** under `roles/` — each is self-contained with `tasks/main.yml`, `vars/main.yml`, and optional `handlers/`
- **Shared tasks:** Each role that requires an APT repository (docker, editors, vagrant, containerlab) handles its own keyring download and repository setup, following the aligned convention in "APT repository setup" below.
- **group_vars:** two files serve different purposes:
  - `group_vars/Ubuntu.yml` — **live config** (the file Ansible actually reads; `ansible_user: zulu`, `storage_root: /storage`)
  - `group_vars/example.yml` — documented template for others to copy
  - **Trap:** new vars must be added to **both** files, or the live run fails with undefined variable errors
- **`/storage` layout** — hardcoded data partition root for Docker data-root, Vagrant home, libvirt images. Single-machine assumption, not portable.

## Role Structure (new)

| Role | Tag | Scope |
|------|-----|-------|
| `setup_base` | `base` | CLI utils + Python system packages (headless-compatible) |
| `setup_pipx` | `pipx` | pipx-managed tools (uv, ruff) — explicit PATH, no shell sourcing |
| `setup_editors` | `editors` | VS Code (APT) + Neovim (snap) |
| `setup_desktop` | `desktop` | GUI packages + snaps (desktop-only) |
| `setup_dotfiles` | `dotfiles` | Dotfiles symlinks |
| `setup_fonts` | `fonts` | JetBrainsMono Nerd Font |
| `setup_docker` | `docker` | Docker Engine + config |
| `setup_containerlab` | `containerlab` | Containerlab |
| `setup_vagrant` | `vagrant` | Vagrant + libvirt/KVM (all virtualization packages merged) |
| `setup_gnome` | `gnome` | GNOME dconf preferences |
| `setup_netlab` | `netlab` | NetworkLab CLI (requires `setup_pipx` for the user pipx install) |

## Key Conventions

### `become: false` for user-owned tasks

The play-level default is `become: true`. Tasks that must run as the connecting user (dotfiles symlinks, uv install, vagrant plugin, font cache) opt out with `become: false`. Do not use `become_user` without `become: true` — it's a silent no-op and tasks will run as root.

### Variable naming: tool prefix, not role prefix

Roles use short prefixes (`docker_`, `vagrant_`, `vscode_`) instead of `setup_docker_`. This is codified as a skip in `.ansible-lint` (`var-naming[no-role-prefix]`) — don't rename to satisfy the linter.

### `ansible_facts['...']` access, never top-level `ansible_*` vars

Always access facts via `ansible_facts['...']` (e.g. `ansible_facts['distribution_release']`, `ansible_facts['architecture']`), never the top-level `ansible_*` vars (`ansible_distribution_release`, `ansible_architecture`). Top-level injection is deprecated (`INJECT_FACTS_AS_VARS`) and will be removed in ansible-core 2.24 — the live run emits a deprecation warning otherwise. Also avoid `ansible_facts['lsb']['codename']`: the `lsb` dict is not reliably populated by fact gathering.

### Lint rules are intentional

`.ansible-lint` and `.yamllint` encode repo conventions (short var names, `yes/no` booleans, 160-char lines, flow-mapping braces). When a linter flags something, judge whether it's a convention skip or genuine debt before changing code.

### `# noqa` on installer tasks

Tasks that run `curl | sh` or similar get inline `# noqa` annotations with a short rationale — these are conditional fallback installs, not security issues to fix.

### APT repository setup (aligned convention)

All repo-owning roles follow the same pattern (aligned with vendor docs for Docker, VS Code, HashiCorp):

- **Armored keys, no dearmor:** `get_url` downloads the `.asc` key and `signed-by=` points at the `.asc` directly. Never de-armor to `.gpg` (modern apt accepts armored keys).
- **Dynamic arch:** the repo line uses `{tool}_apt_arch` — a dict mapping `x86_64`→`amd64`, `aarch64`→`arm64`, with an `amd64` fallback. Never hardcode `arch=amd64`.
- **Prerequisites:** every repo role declares `software-properties-common` (the `apt_repository` module's requirement) in its own deps list.
- **Containerlab is the exception:** its repo is unsigned, so `trusted=yes` is the official spec (commented in vars) — there is no key to download or pin.

## Gotchas

- **Ubuntu 26 + sudo-rs:** Ansible's `become` can hang if the system uses `sudo-rs`. Workaround: `sudo update-alternatives --set sudo /usr/bin/sudo.ws` (documented in README).
- **Dotfiles clone** pins `update: no` for idempotent convergence — this is intentional, not `latest[git]` debt.
- **Docker data migration** uses `cp -a /.` (not `/*`) to preserve dotfiles/hidden files during the `/var/lib/docker` → `/storage` move.
- **`ansible -e 'key=value with spaces'` truncates at the first space** — pass spaced values as JSON (`-e '{"key": "value with spaces"}'`). Not an issue for vars set in `group_vars`.
