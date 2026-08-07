# Ansible Ubuntu Setting

Automate an Ubuntu desktop setup with Ansible. This repository provides role-based playbooks that install packages, deploy dotfiles, configure Docker, install developer fonts, apply GNOME preferences, set up Containerlab, and provision Vagrant with libvirt/KVM — so your desktop configuration is version-controlled and repeatable.

## Quick facts

- Target: Ubuntu 26.04 LTS (desktop); also supports 22.04 and 24.04
- Control machine: any system with Git, Python, and Ansible
- Roles are tagged, so you can run the whole playbook or just a subset

## Features

- **Package installs** — base utilities (bat, zsh, fzf, starship, …), Python dev tooling, and virtualization packages, all in one role
- **`uv`** — installs Astral's `uv` and uses it to provide standalone Python interpreters where needed
- **Snap apps** — `nvim` and `ruff` via the `community.general.snap` module
- **VS Code** — installs from Microsoft's official APT repository
- **Dotfiles** — clones your dotfiles repo and symlinks shell configs, editors, SSH, and theme files into `~`
- **Developer fonts** — JetBrainsMono Nerd Font, with font-cache refresh
- **Docker** — Docker Engine from the official APT repo, `docker` group membership, and a configurable data root
- **Containerlab** — network lab automation with an optional Vagrant/Libvirt VM profile
- **Vagrant + libvirt/KVM** — Vagrant, `vagrant-libvirt`, and a reconfigured libvirt storage pool
- **GNOME preferences** — dconf-driven desktop settings
- **netlab** — NetworkLab CLI (`netlab`) via pipx, pinned to the `ansible-core`/`paramiko` versions that actually work with it
- **Shared APT keyring** — one common task for GPG keyring + repository setup reused by docker/vscode/vagrant
- **Idempotent** — re-running the playbook converges to the desired state without reapplying unchanged work

## Prerequisites

- Git
- Python 3 with the `venv` module
- A non-root sudo user (roles run with privilege escalation)

## Setup

1. Clone the repository and change into it:

```bash
git clone https://github.com/sydasif/ansible-ubuntu-setting.git
cd ansible-ubuntu-setting
```

2. Create a Python virtual environment and install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

The inventory script requires the `distro` package, which `requirements.txt` includes.

3. Create group variables for your host and edit them:

```bash
cp group_vars/example.yml group_vars/Ubuntu.yml
# edit group_vars/Ubuntu.yml (ansible_user, storage_root)
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
ansible-playbook local.yml --tags "fonts,docker"   # packages + docker only
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

- **`setup_packages`** — base utilities, `uv`, Python and virtualization apt packages, and `nvim` + `ruff` via snap
- **`setup_vscode`** — VS Code from Microsoft's apt repo (uses the shared keyring task)
- **`setup_dotfiles`** — clones dotfiles into `~/.dotfiles` and symlinks them into `~`
- **`setup_fonts`** — installs JetBrainsMono Nerd Font and refreshes the font cache
- **`setup_docker`** — Docker Engine, `docker` group, `daemon.json` data root, and a systemd override
- **`setup_containerlab`** — Containerlab, plus an optional Vagrant/Libvirt VM profile
- **`setup_vagrant`** — Vagrant, libvirt/KVM, and the `vagrant-libvirt` plugin
- **`setup_gnome`** — GNOME desktop preferences via dconf
- **`setup_netlab`** — NetworkLab CLI via pip, pinned to compatible Ansible/Paramiko versions
- **`common`** — shared APT keyring tasks reused by other roles

## Project Structure

```text
ansible-ubuntu-setting/
├── local.yml                  # main playbook (roles tagged for selective runs)
├── ansible.cfg                # Ansible configuration
├── requirements.txt           # Python dependencies
├── .ansible-lint / .yamllint  # linter configuration
├── group_vars/                # per-host overrides (Ubuntu.yml, example.yml)
├── roles/                     # role implementations
│   ├── common/                # shared APT keyring / repo tasks
│   ├── setup_packages/  setup_vscode/  setup_dotfiles/  setup_fonts/
│   ├── setup_docker/    setup_containerlab/  setup_vagrant/
│   └── setup_gnome/     setup_netlab/
└── scripts/
    └── inventory.py           # optional dynamic local inventory
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. This repository includes GitHub Actions that run `yamllint`, `ansible-lint`, and an `ansible-playbook --syntax-check` on every push and pull request.

## License

MIT License — see the [LICENSE](LICENSE) file for details.

## References

- Inspiration: [LearnLinuxTV Ansible tutorials](https://youtube.com/playlist?list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70&si=xyQjsGnligtKQFk1)
