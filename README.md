# Desktop as Code: Automating Ubuntu Setup with Ansible

![Ansible Desktop Tutorial Logo](https://www.learnlinux.tv/wp-content/uploads/2020/12/ansible-e1607524003363.png)

### A. The Pain of Manual System Setup

Setting up a new development environment or configuring multiple machines can be a tedious and error-prone process. Manually installing packages, configuring dotfiles, and customizing desktop environments consumes valuable time and often leads to inconsistencies. More critically, it leaves your environment without a code-driven backup or a quick, reliable restoration mechanism. This is where automation becomes invaluable, allowing developers and engineers to treat their **desktop as code**.

### B. Introducing the Project

The project is a practical Ansible playbook designed to bring the **Desktop as Code** concept to life by automating the setup and configuration of a desktop environment. It streamlines the process of getting a new Ubuntu machine ready for development or daily use, ensuring consistency, saving time, and providing a robust, code-driven solution for environment backup and rapid restoration.

### C. What is Ansible?

Ansible is an open-source automation engine that automates software provisioning, configuration management, and application deployment. It's agentless, meaning it communicates over standard SSH, making it easy to set up and use.

### D. Target Audience: Developers, DevOps Engineers, Linux Enthusiasts

This project is ideal for anyone who frequently sets up Ubuntu machines and wants to manage their desktop as code:

* **Developers:** Quickly provision a consistent development environment, treating their entire setup as a version-controlled asset.
* **DevOps Engineers:** Maintain uniformity across multiple test or staging machines, ensuring environments are easily reproducible and quickly restorable.
* **Linux Enthusiasts:** Easily customize, backup, and restore their personal Ubuntu setups with a simple command.

## II. Project Overview: What Does It Do?

The project automates several common Ubuntu configurations, ensuring a consistent and efficient setup.

### A. Automates Common Ubuntu Configurations

The playbook handles a wide array of configurations, from system-level packages to user-specific settings.

### B. Ensures Consistency Across Multiple Machines

By defining configurations in Ansible playbooks, you eliminate the "it works on my machine" problem, ensuring all your Ubuntu desktops are configured identically.

### C. Saves Time and Reduces Errors

Automating repetitive tasks drastically cuts down setup time and minimizes human errors that often occur during manual configurations. It transforms your desktop setup into a repeatable, auditable process, effectively creating a "code backup" of your entire system configuration.

### D. Key Features: Package Installation, Dotfile Management, Docker Setup, GNOME Customization, Font Installation

The project focuses on these core areas:

* **Package Installation:** Installs essential software.
* **Dotfile Management:** Manages configuration files for various applications.
* **Docker Setup:** Automates Docker installation and configuration.
* **GNOME Customization:** Personalizes the desktop environment.
* **Font Installation:** Installs custom fonts for an enhanced visual experience.

## III. Diving into the Ansible Roles

The project is structured into several Ansible roles, each responsible for a specific aspect of the Ubuntu setup.

### A. `setup_packages`: Essential Software Installation

This role ensures that your Ubuntu system has all the necessary software. It uses Ansible's `apt` module to install packages.

1. **How it handles essential software installation (e.g., `apt` packages)**
    The `setup_packages` role defines lists of packages for different categories (base, networking, Python, virtualization) and installs them using `apt`. It also ensures the package cache is updated.

2.  **Example: Installing `git`, `vim`, `zsh`**
    The `base_packages` list includes fundamental tools like `bat`, `git`, `tar`, `vim`, `zsh`, `htop`, `tmux`, `tree`, `wget`, `unzip`, `curl`, `lsd`, and `gnome-tweaks`.
    `network_packages` includes `nmap`, `iperf3`, `net-tools`, `traceroute`.
    `python_packages` includes `python3-pip`, `python3-venv`, `python3-psutil`.
    `virtualization_packages` includes `bridge-utils`, `cloud-init`, `cloud-utils`, `genisoimage`, `libguestfs-tools`, `libvirt-clients`, `libvirt-daemon-system`, `libvirt-dev`, `qemu-kvm`, `qemu-utils`, `virtinst`, and `virt-manager`.

### B. `setup_dotfiles`: Managing Configuration Files

This role automates the management of your personal configuration files, often referred to as "dotfiles."

1.  **Managing configuration files (e.g., `.bashrc`, `.zshrc`, `.gitconfig`)**
    The role clones a specified dotfiles Git repository (`https://github.com/sydasif/dotfiles.git`) to `~/.dotfiles`. It then creates symlinks from this repository to the appropriate locations in the user's home directory.

2.  **Importance of version control for dotfiles**
    Using version control for dotfiles allows you to track changes, easily revert to previous configurations, and synchronize your settings across multiple machines. The project manages files such as:
    *   `.bashrc`
    *   `.vimrc`
    *   `.zshrc`
    *   `.p10k.zsh`
    *   `ruff.toml` (for `~/.config/ruff/ruff.toml`)
    *   `.gitconfig`
    *   `.gitignore`
    *   `settings.json` (for `~/.config/Code/User/settings.json`)
    It also installs the Dracula theme for Vim.

### C. `setup_docker`: Automating Docker Installation and Configuration

This role handles the complete setup of Docker on your Ubuntu machine.

1.  **Automating Docker installation and configuration**
    The role installs necessary dependencies (`apt-transport-https`, `ca-certificates`, `curl`, `gnupg-agent`, `software-properties-common`), adds the Docker GPG key, configures the Docker APT repository, and installs the Docker engine (`docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`).

2.  **Setting up user permissions for Docker**
    Crucially, it adds the current user to the `docker` group, allowing them to run Docker commands without `sudo`. It also installs Containerlab.

### D. `setup_gnome`: Customizing the GNOME Desktop Environment

This role personalizes your GNOME desktop experience.

1.  **Customizing the GNOME desktop environment**
    It copies custom wallpapers (`ubuntu_wallpaper.jpg`, `default_wallpaper.jpg`) to `/usr/share/backgrounds`. It also sets up `dconf` directories and deploys `dconf` settings for both the general GNOME desktop and the GDM (login screen).

2.  **Importing `dconf` settings for terminal, wallpaper, etc.**
    The `dconf_gnome.ini` file configures various aspects like the default wallpaper (`file:///usr/share/backgrounds/default_wallpaper.jpg`), font (`MesloLGS NF 11`), GTK theme (`Adwaita-dark`), and terminal profile settings (e.g., background/foreground colors, font `JetBrainsMono Nerd Font 12`, transparency). The `dconf_gdm.ini` sets the GDM background wallpaper.

### E. `setup_fonts`: Installing Custom Fonts

This role enhances your terminal and code editor experience by installing custom fonts.

1.  **Installing custom fonts for a better development experience**
    The role ensures a `~/.fonts` directory exists and then downloads and unarchives popular Nerd Fonts:
    *   **JetBrainsMono Nerd Font:** Downloaded from `https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz`.
    *   **MesloLGS NF:** Downloaded from `https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.tar.xz`.
    These fonts are commonly used in development for their clear legibility and extensive icon sets.

### F. Other Components: `ansible.cfg`, `local.yml`, `group_vars`, `scripts/inventory.py`

*   **`ansible.cfg`:** The main Ansible configuration file.
*   **`local.yml`:** The main playbook that orchestrates the execution of all roles.
*   **`group_vars/Ubuntu.yml`:** Contains variables specific to Ubuntu hosts, allowing for easy customization of packages, dotfiles, etc.
*   **`scripts/inventory.py`:** A dynamic inventory script to manage target hosts.

## IV. How to Use This Project

### A. Prerequisites: Ansible Installation, Target Ubuntu Machine

Before you begin, ensure you have:
*   **Git:** Installed on your control machine.
*   **Ansible:** Installed on your control machine.
*   **Target Ubuntu Machine:** A fresh or existing Ubuntu 24.04 (or compatible) system to configure.

### B. Cloning the Repository

```bash
git clone https://github.com/sydasif/ubuntu_desktop_config.git
cd ubuntu_desktop_config
```

### C. Understanding `local.yml` (the main playbook)

`local.yml` is the entry point. It defines the hosts to target (`all`), ensures `gather_facts` is true, and uses `become: true` for privilege escalation. It also includes a `pre_task` to update the APT cache and then lists all the roles to be executed in order: `setup_packages`, `setup_dotfiles`, `setup_fonts`, `setup_docker`, `setup_gnome`.

### D. Customizing `group_vars/Ubuntu.yml` for Specific Needs

For specific customizations, you can modify the project. This allows you to override default variables, such as adding or removing packages, changing dotfile repository URLs, or adjusting other role-specific settings without altering the main playbook or roles.

### E. Running the Playbook: `ansible-playbook local.yml`

To execute the playbook, use the following command:
```bash
ansible-playbook local.yml --ask-become-pass
```
The `scripts/inventory.py` flag specifies the dynamic inventory script, and `--ask-become-pass` prompts for the `sudo` password required for privileged tasks.

### F. Idempotency and Re-running the Playbook

Ansible playbooks are designed to be idempotent. This means you can run the playbook multiple times without fear of breaking your system or making unintended changes. If a package is already installed, Ansible won't try to install it again. This is incredibly useful for maintaining system state and applying incremental updates.

## VII. Conclusion

The project demonstrates the power of treating your **desktop as code**. It offers a robust and efficient solution for automating Ubuntu desktop configurations. It simplifies system setup, ensures consistency, and saves valuable time for developers, DevOps engineers, and Linux enthusiasts alike. With this approach, your desktop becomes reproducible, portable, and resilient.

### B. Encouragement for Readers to Try It Out and Contribute

We encourage you to explore this project, adapt it to your needs, and contribute to its improvement. Your feedback and contributions are highly valued!

### C. Future Possibilities and Improvements

Future enhancements could include more extensive desktop environment customizations, support for additional applications, and integration with cloud provisioning tools for fully automated deployments.

## References

*   **Inspiration:** [https://github.com/Addvilz/dots](https://github.com/Addvilz/dots)
*   **Boilerplate:** [https://github.com/LearnLinuxTV/ansible_pull_tutorial](https://github.com/LearnLinuxTV/ansible_pull_tutorial)
