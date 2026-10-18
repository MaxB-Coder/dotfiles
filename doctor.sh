#!/bin/bash
# Check the dotfiles setup on this machine: tools, versions, links, startup.
# Safe to run any time; it only reads. Usage: ./doctor.sh

DOTFILES="$HOME/dotfiles"
problems=0

ok()   { echo "  [ ✓  ] $1"; }
warn() { echo "  [ !  ] $1"; problems=$((problems + 1)); }
section() { echo; echo "$1"; }

# True when version $1 is at least $2
at_least() { [ "$(printf '%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]; }

tool() { # name, command, version command, minimum version (optional)
  local name="$1" cmd="$2" version_cmd="$3" min="$4" version
  if ! command -v "$cmd" &>/dev/null; then
    warn "$name missing (install.sh installs it)"
    return
  fi
  version="$(eval "$version_cmd" 2>/dev/null | grep -oE '[0-9]+(\.[0-9]+)+' | head -1)"
  if [ -n "$min" ] && [ -n "$version" ] && ! at_least "$version" "$min"; then
    warn "$name $version is older than $min"
  else
    ok "$name ${version:-installed}"
  fi
}

linked() { # source in dotfiles, link path
  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
    ok "${2/#$HOME/~}"
  elif [ -e "$2" ]; then
    warn "${2/#$HOME/~} exists but isn't linked to dotfiles"
  else
    warn "${2/#$HOME/~} missing"
  fi
}

# Runtimes come from mise; use its shims so this works outside zsh too
[ -d "$HOME/.local/share/mise/shims" ] && PATH="$HOME/.local/share/mise/shims:$PATH"

case "$OSTYPE" in
  darwin*) OS="mac" ;;
  *) OS="linux" ;;
esac
echo "Dotfiles check ($OS)"

section "Core"
tool "zsh" zsh "zsh --version"
tool "Neovim" nvim "nvim --version" "0.12.0"
tool "Starship" starship "starship --version"
tool "mise" mise "mise --version"
tool "tree-sitter CLI" tree-sitter "tree-sitter --version" "0.26.1"
tool "ripgrep" rg "rg --version"
[ "$OS" = "mac" ] && tool "WezTerm" wezterm "wezterm --version"

section "Runtimes (mise)"
tool "Node" node "node --version"
tool "Go" go "go version"

section "Shell tools"
tool "fzf" fzf "fzf --version"
tool "eza" eza "eza --version | sed -n 2p"
if command -v bat &>/dev/null; then tool "bat" bat "bat --version"; else tool "bat" batcat "batcat --version"; fi
tool "delta" delta "delta --version"
tool "zoxide" zoxide "zoxide --version"

section "Links"
linked "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
linked "$DOTFILES/nvim" "$HOME/.config/nvim"
linked "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
linked "$DOTFILES/mise/config.toml" "$HOME/.config/mise/config.toml"
if [ "$OS" = "mac" ]; then
  linked "$DOTFILES/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
  linked "$DOTFILES/wezterm/palette.lua" "$HOME/.config/wezterm/palette.lua"
fi

section "Git"
if git config --global --get-all include.path | grep -q "dotfiles/git/delta.gitconfig"; then
  ok "diffs use delta"
else
  warn "delta include missing from ~/.gitconfig"
fi

section "Shell startup"
zsh -l -i -c exit &>/dev/null # warm-up run, so caches don't skew the timing
start="$( { /usr/bin/time -p zsh -l -i -c exit; } 2>&1 | awk '/^real/ {print $2}')"
if [ -n "$start" ] && awk "BEGIN {exit !($start < 0.5)}"; then
  ok "new shell starts in ${start}s"
else
  warn "new shell takes ${start:-?}s (aim: under 0.5s; profile with zprof)"
fi

echo
if [ "$problems" -eq 0 ]; then
  echo "  All good."
else
  echo "  $problems thing(s) to look at. Running ./install.sh fixes most of them."
fi
