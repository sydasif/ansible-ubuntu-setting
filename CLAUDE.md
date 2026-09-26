# CLAUDE.md

Guidance for Claude Code working in this repository. This file records **decisions and gotchas** — mechanism detail lives in the code (each role's `tasks/main.yml` and `vars/main.yml`). If the two disagree, the code is right and this file is stale.

## Commands

```bash
ansible-playbook local.yml --ask-become-pass                  # full provision
ansible-playbook local.yml --tags docker --ask-become-pass   # single role
yamllint ./ && ansible-lint && ansible-playbook local.yml --syntax-check
```

## Conventions

### `become: false` only for user-owned tasks

The play-level default is `become: true`. Opt out only for tasks that must run as the connecting user (dotfiles symlinks, uv/pipx installs, vagrant plugin, font cache). Do not use `become_user` without `become: true` — silent no-op, runs as root. System-path writes (`/usr/local/bin`, `/etc`) must stay `true`.

### Tool prefix, not role prefix

Vars use short prefixes (`docker_`, `vagrant_`, `vscode_`), not `setup_docker_`. Codified as an `.ansible-lint` skip (`var-naming[no-role-prefix]`) — don't rename to satisfy the linter.

### `ansible_facts['...']`, never top-level `ansible_*`

Always `ansible_facts['architecture']`, never `ansible_architecture`. Top-level injection is deprecated (`INJECT_FACTS_AS_VARS`), removed in ansible-core 2.24, and warns now. Also avoid `ansible_facts['lsb']['codename']` — the `lsb` dict isn't reliably populated.

### Lint rules are intentional

`.ansible-lint` and `.yamllint` encode conventions. When one flags something, decide whether it's a convention skip or genuine debt before changing code.

### `set -o pipefail` needs `executable: /bin/bash`

Ubuntu's `/bin/sh` is dash, which rejects `set -o pipefail`. A `shell` task with pipefail in the body but no `executable` **passes ansible-lint and then fails at runtime** with `Illegal option -o pipefail`. See `roles/setup_base/tasks/main.yml`.

### APT repositories

`setup_editors` (VS Code), `setup_docker`, `setup_vagrant` own a repo; each handles its own keyring. Aligned with vendor docs:

- **Armored keys, no dearmor:** `get_url` fetches the `.asc`, `signed-by=` points at it. Never de-armor to `.gpg`.
- **Dynamic arch:** use `{tool}_apt_arch` — dict mapping `x86_64`→`amd64`, `aarch64`→`arm64`, `amd64` fallback. Never hardcode `arch=amd64`.
- **Prerequisites:** each repo role declares `software-properties-common` in its own deps list.

`setup_base` and `setup_containerlab` do **not** own a repo — `gh` comes from the Ubuntu archive, containerlab uses `get.containerlab.dev`.

### `group_vars` — add to both files

`Ubuntu.yml` is live config; `example.yml` is the template. **New vars must go in both** or the live run fails on undefined variables.

## Gotchas

- **Ubuntu 26 + sudo-rs:** `become` can hang. Fix: `sudo update-alternatives --set sudo /usr/bin/sudo.ws`.
- **Dotfiles clone** pins `update: no` for idempotency — intentional, not `latest[git]` debt. Don't "fix" it.
- **setup_netlab meta dependency** — `meta/main.yml` declares `dependencies: [setup_pipx]`, so pipx tasks run twice in a full pass. Intentional: without it `--tags netlab` fails on a fresh host. **Do not remove it.**
- **`ansible -e 'key=value with spaces'` truncates at the first space.** Pass JSON: `-e '{"key": "value with spaces"}'`. Only affects CLI extras.
- **Installer scripts are unverified.** Starship and containerlab install via `curl | sh` with no checksum (upstream default). Accepted tradeoff — don't assume they're pinned.
