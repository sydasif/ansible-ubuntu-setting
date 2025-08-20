# Ubuntu 24.04 Configuration with Ansible

![Ansible Desktop Tutorial Logo](https://www.learnlinux.tv/wp-content/uploads/2020/12/ansible-e1607524003363.png)

This repository provides an Ansible playbook to automate the setup and configuration of an Ubuntu desktop environment.

## Quick Start

1.  **Clone this repository:**
    ```bash
    git clone https://github.com/sydasif/ubuntu_desktop_config.git
    cd ubuntu_desktop_config
    ```

2.  **Install Ansible:**
    ```bash
    sudo apt update
    sudo apt install ansible
    ```

3.  **Run the playbook:**
    ```bash
    ansible-playbook local.yml --ask-become-pass
    ```

    This will install essential packages, set up dotfiles, configure GNOME, and apply other system customizations.

## References

*   **Inspiration:** [https://github.com/Addvilz/dots](https://github.com/Addvilz/dots)
*   **Boilerplate:** [https://github.com/LearnLinuxTV/ansible_pull_tutorial](https://github.com/LearnLinuxTV/ansible_pull_tutorial)
