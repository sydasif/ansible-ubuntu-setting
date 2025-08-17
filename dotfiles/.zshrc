# ------------------------------
# Powerlevel10k Instant Prompt
# ------------------------------
# Loads Powerlevel10k's instant prompt feature very early to speed up shell start.
# Keep this block near the top of the file.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------
# Zinit Plugin Manager Setup
# ------------------------------
# Define where Zinit will store itself and its plugins.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it’s not already installed.
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ------------------------------
# Themes and Plugins via Zinit
# ------------------------------

# Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Syntax highlighting, completions, autosuggestions, and fzf-tab for fuzzy completion
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load zsh completion system
autoload -Uz compinit && compinit

# Common Oh-My-Zsh snippets (git aliases, sudo shortcuts, command-not-found helper)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# ------------------------------
# Keybindings
# ------------------------------
bindkey -e                     # Use emacs-style keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ------------------------------
# History Configuration
# ------------------------------
HISTSIZE=5000                  # Max number of lines kept in memory
HISTFILE=~/.zsh_history        # File where history is stored
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory           # Append to history file instead of overwriting
setopt sharehistory            # Share history between sessions
setopt hist_ignore_space       # Ignore commands starting with a space
setopt hist_ignore_all_dups    # Remove all older duplicates
setopt hist_save_no_dups       # Don’t save duplicates in history file
setopt hist_ignore_dups        # Ignore duplicate commands
setopt hist_find_no_dups       # Don’t show duplicate matches during search

# ------------------------------
# Powerlevel10k Config
# ------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------
# Completion Styling
# ------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# ------------------------------
# Aliases
# ------------------------------
alias ip='ip -c'
alias lsd="lsd -F"
alias ls="lsd -F"

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# ------------------------------
# FZF Keybindings and Autocomplete
# ------------------------------
# Make sure you have installed fzf with:
#   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#   ~/.fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LIBVIRT_DEFAULT_URI="qemu:///system"
export PATH="$PATH:$HOME/go/bin"
