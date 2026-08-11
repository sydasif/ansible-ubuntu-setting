# Ansible Ubuntu Setting

Automate an Ubuntu desktop setup with Ansible. This repository provides role-based playbooks that install packages, deploy dotfiles, configure Docker, install developer fonts, apply GNOME preferences, set up Containerlab, and provision Vagrant with libvirt/KVM — so your desktop configuration is version-controlled and repeatable.

## Quick facts

- Target: Ubuntu 26.04 LTS (desktop); also supports 22.04 and 24.04
- Control machine: any system with Git, Python, and Ansible
- Roles are tagged, so you can run the whole playbook or just a subset

## Features

- **Base packages** — CLI utilities (bat, zsh, fzf, starship, git, …) and Python system packages (python3-pip, python3-venv) — runs on headless servers too
- **Desktop packages** — GUI packages (gnome-tweaks)
- **Editors** — VS Code (Microsoft APT repo) and Neovim (snap)
- **Dotfiles** — clones your dotfiles repo and symlinks shell configs, editors, SSH, and theme files into `~`
- **Developer fonts** — JetBrainsMono Nerd Font, with font-cache refresh
- **Docker** — Docker Engine from the official APT repo, `docker` group membership, and a configurable data root. Log out and back in after provisioning so the `docker` group membership takes effect without `sudo`
- **Containerlab** — network lab automation
- **Vagrant + libvirt/KVM** — Vagrant, `vagrant-libvirt`, and a reconfigured libvirt storage pool
- **GNOME preferences** — dconf-driven desktop settings, with Ptyxis registered as the xdg default terminal
- **netlab** — NetworkLab CLI (`netlab`) via pipx, pinned to the `ansible-core`/`paramiko` versions that actually work with it
- **Idempotent** — re-running the playbook converges to the desired state without reapplying unchanged work

## Prerequisites

- Git
- Python 3 with the `venv` module
- A non-root sudo user (roles run with privilege escalation)

## Setup

- Clone the repository and change into it:

```bash
git clone https://github.com/sydasif/ansible-ubuntu-setting.git
cd ansible-ubuntu-setting
```

- Create a Python virtual environment and install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

The inventory script requires the `distro` package, which `requirements.txt` includes.

- Install required Ansible Galaxy collections:

```bash
ansible-galaxy collection install -r requirements.yml
```

> **Note:** This step is required before running the `editors`, `netlab`, or `vagrant` tags (`community.general` and `community.libvirt`).

- Create group variables for your host and edit them:

```bash
# edit group_vars/Ubuntu.yml (ansible_user, user_home, storage_root)
cp group_vars/example.yml group_vars/Ubuntu.yml
```

## Usage

Run the full playbook (using the included dynamic inventory):

```bash
ansible-playbook local.yml --ask-become-pass
```

`scripts/inventory.py` is a dynamic inventory that auto-detects your local Ubuntu system. `local.yml` sets `become: true`, and the `ansible.cfg` enables password-less escalation only when you pass `--ask-become-pass`.

### Run specific roles

Roles in `local.yml` are tagged. Use `--tags` to run a subset:

```bash
ansible-playbook local.yml --tags "base,editors,docker"   # base + editors + docker only
ansible-playbook local.yml --tags base        # CLI utilities + Python packages (headless-friendly)
ansible-playbook local.yml --tags desktop     # GUI packages
ansible-playbook local.yml --tags editors     # VS Code + Neovim
ansible-playbook local.yml --tags dotfiles
ansible-playbook local.yml --tags vagrant
ansible-playbook local.yml --tags netlab
```

Each role runs as the `ansible_user` account unless it needs root.

## Configuration

- `group_vars/Ubuntu.yml` — per-host overrides (see `group_vars/example.yml` for the canonical example)
- Role-specific values live in each role's `vars/main.yml`: package lists, repo URLs, dotfiles repo, storage paths, etc.

Keep secrets out of the repository; use Ansible Vault or an external secret store.

## Usage / Roles

Each `setup_*` role installs and configures one tool:

- **`setup_base`** — CLI utilities (bat, zsh, fzf, starship, git, …) and Python system packages (python3-pip, python3-venv) — runs on headless servers
- **`setup_desktop`** — GUI packages (gnome-tweaks)
- **`setup_editors`** — VS Code (Microsoft APT repo) and Neovim (snap)
- **`setup_pipx`** — pipx-managed CLI tools: pipx (with uv backend), uv, ruff
- **`setup_dotfiles`** — clones dotfiles into `~/.dotfiles` and symlinks them into `~`
- **`setup_fonts`** — installs JetBrainsMono Nerd Font and refreshes the font cache
- **`setup_docker`** — Docker Engine (official APT repo), `docker` group membership, `daemon.json` data root on `/storage`, and the Docker service enabled/started
- **`setup_containerlab`** — Containerlab network lab automation
- **`setup_vagrant`** — Vagrant, libvirt/KVM (including bridge-utils, qemu, virt-manager, libguestfs-tools), and the `vagrant-libvirt` plugin. Requires the `community.libvirt` Ansible collection and `python3-libvirt`/`python3-lxml` Python packages (installed automatically)
- **`setup_gnome`** — GNOME desktop preferences via dconf, and registers Ptyxis as the default/xdg terminal (Ubuntu 26 dropped `gnome-terminal`)
- **`setup_netlab`** — NetworkLab CLI via pipx, pinned to compatible Ansible/Paramiko versions

## Project Structure

```text
ansible-ubuntu-setting/
├── local.yml                  # main playbook (roles tagged for selective runs)
├── ansible.cfg                # Ansible configuration
├── requirements.txt           # Python dependencies
├── .ansible-lint / .yamllint  # linter configuration
├── group_vars/                # per-host overrides (Ubuntu.yml, example.yml)
├── roles/                     # role implementations
│   ├── setup_base/            # CLI utilities + Python system packages
│   ├── setup_desktop/         # GUI packages
│   ├── setup_editors/         # VS Code + Neovim
│   ├── setup_pipx/            # pipx-managed tools (pipx, uv, ruff)
│   ├── setup_dotfiles/        # dotfiles symlinks
│   ├── setup_fonts/           # JetBrainsMono Nerd Font
│   ├── setup_docker/          # Docker Engine + config
│   ├── setup_containerlab/    # Containerlab
│   ├── setup_vagrant/         # Vagrant + libvirt/KVM
│   ├── setup_gnome/           # GNOME dconf preferences
│   └── setup_netlab/          # NetworkLab CLI
└── scripts/
    └── inventory.py           # optional dynamic local inventory
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. Lint locally with `yamllint ./`, `ansible-lint`, and `ansible-playbook --syntax-check` before committing.

## License

MIT License — see the [LICENSE](LICENSE) file for details.

## References

- Inspiration: [LearnLinuxTV Ansible tutorials](https://youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70&si=xyQjsGnligtKQFk1)
