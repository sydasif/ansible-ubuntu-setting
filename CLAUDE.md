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

# Lint / validate (CI runs all three)
yamllint ./
ansible-lint
ansible-playbook local.yml --syntax-check
```

## Architecture

- **Entry point:** `local.yml` — single play, `become: true`, hosts `all` (resolved by `scripts/inventory.py` to the local machine as its distro group, e.g. `Ubuntu`)
- **Roles** under `roles/` — each is self-contained with `tasks/main.yml`, `vars/main.yml`, and optional `handlers/`
- **Shared include:** `roles/common/tasks/apt_keyring.yml` — GPG keyring + repo setup, included by docker/vscode/vagrant roles via `include_tasks` with role-specific vars
- **group_vars:** two files serve different purposes:
  - `group_vars/Ubuntu.yml` — **live config** (the file Ansible actually reads; `ansible_user: zulu`, `storage_root: /storage`)
  - `group_vars/example.yml` — documented template for others to copy
  - **Trap:** new vars must be added to **both** files, or the live run fails with undefined variable errors
- **`/storage` layout** — hardcoded data partition root for Docker data-root, Vagrant home, libvirt images. Single-machine assumption, not portable.

## Key Conventions

### `become: false` for user-owned tasks

The play-level default is `become: true`. Tasks that must run as the connecting user (dotfiles symlinks, uv install, vagrant plugin, font cache) opt out with `become: false`. Do not use `become_user` without `become: true` — it's a silent no-op and tasks will run as root.

### Variable naming: tool prefix, not role prefix

Roles use short prefixes (`docker_`, `vagrant_`, `vscode_`) instead of `setup_docker_`. This is codified as a skip in `.ansible-lint` (`var-naming[no-role-prefix]`) — don't rename to satisfy the linter.

### `ansible_facts['distribution_release']`

All roles that reference the Ubuntu codename use `ansible_facts['distribution_release']`, not `ansible_facts['lsb']['codename']`. The `lsb` dict is not reliably populated by fact gathering.

### Lint rules are intentional

`.ansible-lint` and `.yamllint` encode repo conventions (short var names, `yes/no` booleans, 160-char lines, flow-mapping braces). When a linter flags something, judge whether it's a convention skip or genuine debt before changing code.

### `# noqa` on installer tasks

Tasks that run `curl | sh` or similar get inline `# noqa` annotations with a short rationale — these are conditional fallback installs, not security issues to fix.

## Gotchas

- **Ubuntu 26 + sudo-rs:** Ansible's `become` can hang if the system uses `sudo-rs`. Workaround: `sudo update-alternatives --set sudo /usr/bin/sudo.ws` (documented in README).
- **Dotfiles clone** pins `update: no` for idempotent convergence — this is intentional, not `latest[git]` debt.
- **Docker data migration** uses `cp -a /.` (not `/*`) to preserve dotfiles/hidden files during the `/var/lib/docker` → `/storage` move.
