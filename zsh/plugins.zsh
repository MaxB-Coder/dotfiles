# zsh-autosuggestions
if [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting
if [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
