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

# Link $1 (a file in the dotfiles) to $2. Safe to re-run: an existing link to
# the same file is left alone, anything else is moved aside with a timestamp
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    success "$dest already linked"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    info "Moved existing $dest to $backup"
  fi
  ln -s "$src" "$dest"
  success "Linked $dest"
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
  # mise (runtimes: Node, Go, ...)
  if ! command -v mise &>/dev/null; then
    curl -fsSL https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

success "Packages installed"

# =============================================================================
# Symlinks
# =============================================================================

info "Creating symlinks..."

link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/mise/config.toml" "$HOME/.config/mise/config.toml"

# WezTerm (Mac only; on Windows the config lives on the Windows side, see the
# README). palette.lua must sit next to wezterm.lua
if [[ "$OS" == "mac" ]]; then
  link "$DOTFILES/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
  link "$DOTFILES/wezterm/palette.lua" "$HOME/.config/wezterm/palette.lua"
fi

# Git: diffs through delta (only touches ~/.gitconfig to add an include line).
# Skipped without delta, since git can't page through a missing program
if ! command -v delta &>/dev/null; then
  info "delta not installed, git keeps its normal diff view"
elif ! git config --global --get-all include.path | grep -q "dotfiles/git/delta.gitconfig"; then
  git config --global --add include.path "~/dotfiles/git/delta.gitconfig"
  success "Git set up to use delta"
else
  success "Git already uses delta"
fi

# =============================================================================
# Runtimes (mise)
# =============================================================================

# Reuse Node versions installed with nvm instead of downloading them again
[ -d "$HOME/.nvm/versions/node" ] && mise sync node --nvm
info "Installing runtimes from mise/config.toml..."
mise install
success "Runtimes installed"

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
