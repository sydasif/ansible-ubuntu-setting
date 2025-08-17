# Ansible Desktop Configuration

![Ansible Desktop Tutorial Logo](https://www.learnlinux.tv/wp-content/uploads/2020/12/ansible-e1607524003363.png)

This repository contains an Ansible playbook to automate the configuration of an Ubuntu desktop environment. It installs essential packages, sets up dotfiles, configures the GNOME Terminal, and customizes system settings like the desktop background.

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
        ansible-playbook local.yml --tags setup_packages --ask-become-pass
        ```
    *   **Copy dotfiles only:**
        ```bash
        ansible-playbook local.yml --tags setup_dotfiles --ask-become-pass
        ```
    *   **Apply desktop settings only (wallpaper, snaps):**
        ```bash
        ansible-playbook local.yml --tags setup_desktop --ask-become-pass
        ```
    *   **Configure terminal only:**
        ```bash
        ansible-playbook local.yml --tags setup_terminal --ask-become-pass
        ```

    Replace `--ask-become-pass` with `--ask-pass` if you are not using `sudo` for privilege escalation.

## What it Does

*   **Installs Packages (`setup_packages`):** Installs a list of essential packages defined in `group_vars/Ubuntu.yml`. It also handles creating a `bat` symlink for `batcat`.
*   **Deploys Dotfiles (`setup_dotfiles`):** Copies configuration files (dotfiles) from the `dotfiles/` directory to your home directory. It also templates the `.gitconfig` with user-specific details from `group_vars/Ubuntu.yml`.
*   **Configures Desktop (`setup_desktop`):** Sets the desktop wallpaper and installs specified Snap packages.
*   **Installs Fonts (`setup_fonts`):** Copies all fonts from the project's `fonts/` directory into the user's `~/.fonts` directory and refreshes the font cache.
*   **Configures Terminal (`setup_terminal`):** Applies a comprehensive set of theme and behavior settings to a GNOME Terminal profile. The name of the profile to be configured can be specified in `group_vars/Ubuntu.yml` using the `gnome_terminal_profile_name` variable, making it easy to target a non-default profile.
