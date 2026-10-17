# Load all zsh config files
source ~/dotfiles/zsh/exports.zsh
source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/plugins.zsh

# Starship prompt (must be at the end)
eval "$(starship init zsh)"

# Transient prompt: once a command runs, its prompt collapses to "❯ command"
# so scrollback stays clean and only the live prompt shows the pills
zle-line-init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break # Ctrl-D on an empty line
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT saved_rprompt=$RPROMPT
  PROMPT='%B%F{#e07b39}❯%f%b '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Go
export PATH=$PATH:/usr/local/go/bin

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by cua-driver-rs installer — see https://github.com/trycua/cua
export PATH="$HOME/.local/bin:$PATH"

# Java 21 (only if installed)
if /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 21)
  export PATH="$JAVA_HOME/bin:$PATH"
fi
