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

# Gruvbox colours for what you type (matches the WezTerm theme)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#665c54"

ZSH_HIGHLIGHT_STYLES[command]="fg=#b8bb26"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=#b8bb26"
ZSH_HIGHLIGHT_STYLES[alias]="fg=#b8bb26"
ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=#b8bb26"
ZSH_HIGHLIGHT_STYLES[function]="fg=#b8bb26"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=#b8bb26,italic"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=#e07b39"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#fb4934"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=#83a598"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=#83a598"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#fabd2f"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#fabd2f"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=#fabd2f"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=#8ec07c"
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=#8ec07c"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=#8ec07c"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=#8ec07c"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=#d3869b"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#928374"
ZSH_HIGHLIGHT_STYLES[comment]="fg=#928374,italic"
ZSH_HIGHLIGHT_STYLES[path]="underline"
