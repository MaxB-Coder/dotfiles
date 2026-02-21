# Load all zsh config files
source ~/dotfiles/zsh/exports.zsh
source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/plugins.zsh

# Starship prompt (must be at the end)
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
