# Modern CLI tools. Each one is only set up when it's installed, so a machine
# without it still gets a working shell. Colours follow the shared palette
# (~/.config/wezterm/palette.lua)

# bat: cat with syntax colours (Ubuntu names the binary batcat)
if (( $+commands[batcat] && ! $+commands[bat] )); then
  alias bat="batcat"
fi
export BAT_THEME="gruvbox-dark"

# fzf: Ctrl-R history, Ctrl-T files, Alt-C folders
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --info=inline-right \
--prompt='❯ ' --pointer='▌' --marker='▏' --separator='─' \
--color=bg:-1,bg+:#3c3836,fg:#bdae93,fg+:#ebdbb2,hl:#e07b39,hl+:#e07b39 \
--color=border:#504945,gutter:-1,header:#928374,info:#928374,marker:#e07b39 \
--color=pointer:#e07b39,prompt:#e07b39,spinner:#e07b39"
  if (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  if (( $+commands[bat] || $+commands[batcat] )); then
    export FZF_CTRL_T_OPTS="--preview '${commands[bat]:-${commands[batcat]}} --color=always --style=numbers --line-range=:200 {}'"
  fi
  export FZF_ALT_C_OPTS="--preview 'ls -1 {} | head -50'"

  # Key bindings need a terminal, so skip them in scripted shells.
  # fzf 0.48+ prints its own zsh setup; older apt builds ship it as a file
  if [[ ! -t 0 ]]; then
    :
  elif fzf_init="$(fzf --zsh 2>/dev/null)"; then
    eval "$fzf_init"
  elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  fi
  unset fzf_init
fi

# zoxide: `z dot` jumps to the best match for "dot" from folders you've used
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
