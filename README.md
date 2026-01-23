# Ansible Ubuntu Setting

Automate an Ubuntu desktop setup using Ansible. This repository provides role-based playbooks that install packages, deploy dotfiles, configure Docker, install developer fonts, and apply GNOME preferences so your desktop configuration is version-controlled and repeatable.

## Quick facts

- Target: Ubuntu 24.04+ (desktop)
- Control machine: Any system with `Git` and `Ansible`

## Repository layout

- `local.yml` — main playbook (roles are tagged so you can run subsets)
- `ansible.cfg` — project Ansible configuration
- `group_vars/` — `example.yml` provided; copy to `Ubuntu.yml` and customize
- `roles/` — role implementations (packages, dotfiles, docker, fonts, gnome)
- `scripts/inventory.py` — optional dynamic inventory
- `requirements.txt` — Python dependencies

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
```

## Customize

- Edit `group_vars/Ubuntu.yml` to change package lists, dotfiles repository URL, or GNOME preferences.
- Keep secrets out of the repository; use Ansible Vault or an external secret store.

## Idempotency

Roles are written to be idempotent. Re-running the playbook should converge the system to the desired state without repeating already-applied changes.

## Contributing & CI

See `CONTRIBUTING.md` for contribution guidelines. This repository includes GitHub Actions workflows that run `yamllint` and `ansible-lint` on pushes and pull requests.

## License

MIT License - see the `LICENSE` file for details.

## References

- Dotfiles example: [sydasif/dotfiles](https://github.com/sydasif/dotfiles)
- Inspiration: LearnLinuxTV Ansible tutorials
