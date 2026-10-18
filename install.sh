#!/bin/bash

# =============================================================================
# Dotfiles Install Script
# https://github.com/MaxB-Coder/dotfiles
# =============================================================================

set -e  # exit immediately if any command fails

echo "🚀 Starting dotfiles installation..."

# =============================================================================
# Helpers
# =============================================================================

info()    { echo "  [ .. ] $1"; }
success() { echo "  [ ✓  ] $1"; }
error()   { echo "  [ ✗  ] $1"; exit 1; }

# Clear the way for chezmoi's links. Links from the layout before chezmoi
# (pointing into ~/dotfiles but not ~/dotfiles/home) are removed; real files
# where chezmoi wants a link (a fresh machine's .zshrc, say) are moved aside
# with a timestamp. Safe to re-run: chezmoi's own links are left alone
prepare_targets() {
  local stamp target dest
  stamp="$(date +%Y%m%d%H%M%S)"
  for target in "$HOME/.zshrc" "$HOME/.config/nvim" "$HOME/.config/starship.toml" \
    "$HOME/.config/wezterm/wezterm.lua" "$HOME/.config/wezterm/palette.lua" "$HOME/.config/mise/config.toml"; do
    dest="$(readlink "$target" 2>/dev/null)" || continue
    if [[ "$dest" == "$DOTFILES/"* && "$dest" != "$DOTFILES/home/"* ]]; then
      rm "$target"
      info "Removed old link ${target/#$HOME/~}"
    fi
  done
  while read -r target; do
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      mv "$target" "$target.bak.$stamp"
      info "Moved existing ${target/#$HOME/~} to ${target/#$HOME/~}.bak.$stamp"
    fi
  done < <(chezmoi managed --source "$DOTFILES" --exclude=dirs,scripts --path-style=absolute)
}

# Neovim on Linux: apt ships 0.9, but the config needs 0.12+ (Treesitter main),
# so install the official release into /opt/nvim when it's missing or too old
NVIM_MIN_VERSION="0.12.0"
install_neovim_linux() {
  local current=""
  if command -v nvim &>/dev/null; then
    current="$(nvim --version | head -1 | sed -E 's/^NVIM v([0-9.]+).*/\1/')"
  fi
  if [ -n "$current" ] && [ "$(printf '%s\n' "$NVIM_MIN_VERSION" "$current" | sort -V | head -1)" = "$NVIM_MIN_VERSION" ]; then
    success "Neovim $current already installed"
    return
  fi

  local arch
  case "$(uname -m)" in
    x86_64) arch="x86_64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *) error "Unsupported CPU for Neovim release: $(uname -m)" ;;
  esac

  info "Installing latest Neovim release..."
  local tarball
  tarball="$(mktemp)"
  curl -fsSL -o "$tarball" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$arch.tar.gz"
  sudo rm -rf /opt/nvim
  sudo mkdir -p /opt/nvim
  sudo tar -xzf "$tarball" -C /opt/nvim --strip-components=1
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm -f "$tarball"
  success "Neovim $(nvim --version | head -1) installed"
}

# tree-sitter CLI on Linux: nvim-treesitter needs 0.26.1+ to build parsers and
# apt's is too old, so use the official release binary
install_tree_sitter_linux() {
  if command -v tree-sitter &>/dev/null; then
    success "tree-sitter CLI already installed"
    return
  fi
  local arch
  case "$(uname -m)" in
    x86_64) arch="x64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *) error "Unsupported CPU for tree-sitter release: $(uname -m)" ;;
  esac
  info "Installing tree-sitter CLI..."
  curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-$arch.gz" \
    | gunzip | sudo tee /usr/local/bin/tree-sitter >/dev/null
  sudo chmod +x /usr/local/bin/tree-sitter
  success "tree-sitter CLI installed"
}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
else
  error "Unsupported OS: $OSTYPE"
fi

info "Detected OS: $OS"

# =============================================================================
# Dotfiles
# =============================================================================

DOTFILES="$HOME/dotfiles"

if [ ! -d "$DOTFILES" ]; then
  info "Cloning dotfiles..."
  git clone git@github.com:MaxB-Coder/dotfiles.git "$DOTFILES"
  success "Dotfiles cloned"
else
  success "Dotfiles already present"
fi

# =============================================================================
# Homebrew (Mac only)
# =============================================================================

if [[ "$OS" == "mac" ]]; then
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
fi

# =============================================================================
# Packages
# =============================================================================

info "Installing packages..."

if [[ "$OS" == "mac" ]]; then
  # Everything is listed in brew/Brewfile; --no-upgrade keeps re-runs quick
  brew bundle --no-upgrade --file="$DOTFILES/brew/Brewfile"
elif [[ "$OS" == "linux" ]]; then
  sudo apt-get update -qq
  # build-essential: a C compiler so Treesitter can build its parsers
  sudo apt-get install -y git ripgrep curl build-essential zsh-autosuggestions zsh-syntax-highlighting
  # Shell tools: newer Ubuntu has them all, older releases may lack some,
  # so install one at a time and carry on without any that are missing
  for pkg in fzf eza bat git-delta zoxide; do
    sudo apt-get install -y "$pkg" &>/dev/null && success "$pkg installed" || info "$pkg not available from apt, skipped"
  done
  install_neovim_linux
  install_tree_sitter_linux
  # Starship
  curl -sS https://starship.rs/install.sh | sh
  # chezmoi (puts the configs in place)
  if ! command -v chezmoi &>/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
  # mise (runtimes: Node, Go, ...)
  if ! command -v mise &>/dev/null; then
    curl -fsSL https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

success "Packages installed"

# =============================================================================
# Configs (chezmoi)
# =============================================================================

# chezmoi links every file under home/ into place (home/dot_zshrc -> ~/.zshrc,
# home/dot_config/nvim -> ~/.config/nvim, ...), then its scripts in
# home/.chezmoiscripts install the mise runtimes and point git at delta
info "Linking configs with chezmoi..."
chezmoi init --source "$DOTFILES"
prepare_targets
chezmoi apply --source "$DOTFILES"
success "Configs linked (check with: chezmoi verify)"

# =============================================================================
# Zsh as default shell
# =============================================================================

if [[ "$SHELL" != "$(which zsh)" ]]; then
  info "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
  success "Default shell set to zsh"
else
  success "Zsh already default shell"
fi

# =============================================================================
# Done
# =============================================================================

echo ""
echo "  ✅ Installation complete!"
echo "  Open a new terminal session to apply all changes."
echo "  Then open nvim and run :Lazy to install plugins."
echo "  Run ./doctor.sh any time to check the setup."
echo ""
