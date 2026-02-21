# Load all zsh config files
source ~/dotfiles/zsh/exports.zsh
source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/plugins.zsh

# Starship prompt (must be at the end)
eval "$(starship init zsh)"
