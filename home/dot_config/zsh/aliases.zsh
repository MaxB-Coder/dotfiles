# Neovim
alias v="nvim"

# Navigation
alias ..="cd .."
alias ...="cd ../.."

# List files: eza (icons, git status, folders first) when installed
if (( $+commands[eza] )); then
  alias ls="eza --group-directories-first --icons=auto"
  alias ll="eza -la --group-directories-first --icons=auto --git"
  alias tree="eza --tree --icons=auto --git-ignore"
else
  alias ls="ls --color=auto"
  alias ll="ls -la"
fi

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph"

# Dotfiles
alias dotfiles="cd ~/dotfiles"
