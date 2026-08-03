# Ansible Ubuntu Setting

Automate an Ubuntu desktop setup using Ansible. This repository provides role-based playbooks that install packages, deploy dotfiles, configure Docker, install developer fonts, apply GNOME preferences, install Containerlab, and set up Vagrant with libvirt/KVM so your desktop configuration is version-controlled and repeatable.

## Quick facts

- Target: Ubuntu 24.04+ (desktop)
- Control machine: Any system with `Git`, `Python`, and `Ansible`

## Repository layout

- `local.yml` — main playbook (roles are tagged so you can run subsets)
- `ansible.cfg` — project Ansible configuration
- `group_vars/` — `example.yml` provided; copy to `Ubuntu.yml` and customize
- `roles/` — role implementations (packages, vscode, ghostty, dotfiles, docker, containerlab, vagrant, fonts, gnome)
- `scripts/inventory.py` — optional dynamic inventory
- `requirements.txt` — Python dependencies

## Prerequisites

- Git
- Python 3 and `venv` module

## Quick start

1. Clone the repository and change into it:

```bash
git clone https://github.com/sydasif/ansible-ubuntu-setting.git
cd ansible-ubuntu-setting
```

1. Create a Python virtual environment and install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Note: The inventory script requires the 'distro' package which is included in the requirements.txt file.

1. Copy the example group variables and edit them for your environment:

```bash
cp group_vars/example.yml group_vars/Ubuntu.yml
# edit group_vars/Ubuntu.yml (ansible_user, package lists, dotfiles_repo, etc.)
```

1. Run the full playbook (example using the included dynamic inventory):

```bash
ansible-playbook -i scripts/inventory.py local.yml --ask-become-pass
```

Note: The `scripts/inventory.py` is a dynamic inventory script that automatically detects your local Ubuntu system. Make sure you have the required Python dependencies installed (distro package).

### Run specific roles only

Roles in `local.yml` are tagged. Use `--tags` to run a subset:

```bash
# run only fonts and docker roles
ansible-playbook local.yml --tags "fonts,docker"

# run only the dotfiles role
ansible-playbook local.yml --tags dotfiles

# run only the vagrant role
ansible-playbook local.yml --tags vagrant
```

## Customize

- Edit `group_vars/Ubuntu.yml` to change package lists, dotfiles repository URL, GNOME preferences, or VM defaults.
- Keep secrets out of the repository; use Ansible Vault or an external secret store.

## Roles

### packages
Installs base utilities, Python development tools, and virtualization packages.

### vscode
Installs Visual Studio Code from Microsoft’s official APT repository.

### ghostty
Installs Ghostty terminal emulator from its official PPA.

### dotfiles
Clones your dotfiles repository and creates symlinks into your home directory. Also sets the default shell.

### fonts
Installs developer fonts, currently JetBrainsMono Nerd Font, into `~/.fonts` and refreshes the font cache.

### docker
Installs Docker Engine from Docker's official APT repository, adds your user to the `docker` group, and configures Docker to use `/storage/docker` for images and containers.

### containerlab
Installs Containerlab for network lab automation. Skips installation if `containerlab` is already present.

### vagrant
Installs Vagrant, libvirt/KVM, and the `vagrant-libvirt` plugin. Sets Vagrant’s home to `/storage/vagrant` so boxes and related data live on `/storage`. Reconfigures the libvirt default pool to `/storage/libvirt/images` if needed.

Note: The `vagrant-libvirt` plugin compiles native extensions on first install and can take 2–5 minutes. The role handles this with an async install and retry loop.

### gnome
Applies GNOME desktop preferences via dconf, including fonts, theme, and shell settings.

## Troubleshooting

### "Timed out waiting for become success or become password prompt" (Ubuntu 26.04)

Ubuntu 26.04 ships `sudo-rs` (a Rust reimplementation of sudo) as the default `sudo` binary. Sudo-rs handles the password prompt/response cycle differently than traditional sudo, which causes Ansible's `become` to hang and fail with an error like:

```text
[ERROR]: Task failed: Timed out waiting for become success or become password prompt.
```

This happens even when the password is correct and `sudo` works normally in a terminal.

Fix — switch the `sudo` alternative back to classic sudo:

```bash
sudo update-alternatives --set sudo /usr/bin/sudo.ws
```

Verify the fix:

```bash
update-alternatives --display sudo   # should point to /usr/bin/sudo.ws
ansible localhost -b -m command -a whoami --ask-become-pass   # should print: root
```

Note: system updates may reset `update-alternatives` back to `sudo-rs`. If the error resurfaces after an update, run the `update-alternatives` command above again.

## Idempotency

Roles are written to be idempotent. Re-running the playbook should converge the system to the desired state without repeating already-applied changes.

## Contributing & CI

See `CONTRIBUTING.md` for contribution guidelines. This repository includes GitHub Actions workflows that run `yamllint` and `ansible-lint` on pushes and pull requests.

## License

MIT License - see the `LICENSE` file for details.

## References

- Inspiration: LearnLinuxTV Ansible tutorials
