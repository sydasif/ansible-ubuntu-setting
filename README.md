# Ansible Desktop Configuration

![Ansible Desktop Tutorial Logo](https://www.learnlinux.tv/wp-content/uploads/2020/12/ansible-e1607524003363.png)

This repository contains an Ansible playbook to automate the configuration of an Ubuntu desktop environment. It installs essential packages, sets up dotfiles, and configures system settings like the desktop background.

## How to Use

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/sydasif/ubuntu_desktop_config.git
    cd ubuntu_desktop_config
    ```

2.  **Install Ansible (if you haven't already):**
    ```bash
    sudo apt update
    sudo apt install ansible
    ```

3.  **Run the playbook:**
    To run the entire configuration:
    ```bash
    ansible-playbook local.yml --ask-become-pass
    ```

    You can also run specific parts of the configuration using tags:

    *   **Install packages only:**
        ```bash
        ansible-playbook local.yml --tags packages --ask-become-pass
        ```
    *   **Copy dotfiles only:**
        ```bash
        ansible-playbook local.yml --tags dotfiles --ask-become-pass
        ```
    *   **Apply system settings only:**
        ```bash
        ansible-playbook local.yml --tags settings --ask-become-pass
        ```

    Replace `--ask-become-pass` with `--ask-pass` if you are not using `sudo` for privilege escalation.

## What it Does

*   **Installs Packages:** Installs a list of essential packages (htop, tmux, vim, python3-psutil, zsh, bat) defined in `group_vars/Ubuntu.yml`. It also handles creating a `bat` symlink if `batcat` is installed.
*   **Copies Dotfiles:** Copies configuration files (dotfiles) from the `dotfiles/` directory to your home directory, as defined in `group_vars/Ubuntu.yml`.
*   **Configures System Settings:** Sets the desktop wallpaper and other GNOME background settings using `dconf`, as defined in `group_vars/Ubuntu.yml`.
