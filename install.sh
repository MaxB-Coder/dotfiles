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
  brew install neovim git starship ripgrep zsh-autosuggestions zsh-syntax-highlighting figlet
  brew install --cask wezterm font-jetbrains-mono
elif [[ "$OS" == "linux" ]]; then
  sudo apt-get update -qq
  sudo apt-get install -y neovim git ripgrep figlet curl
  # Starship
  curl -sS https://starship.rs/install.sh | sh
  # zsh plugins
  sudo apt-get install -y zsh-autosuggestions zsh-syntax-highlighting
  # Symlink system treesitter parsers
  info "Linking treesitter parsers..."
  mkdir -p "$HOME/.local/share/nvim/site/parser"
  if ls /usr/lib/x86_64-linux-gnu/nvim/parser/*.so 2>/dev/null; then
    ln -sf /usr/lib/x86_64-linux-gnu/nvim/parser/*.so "$HOME/.local/share/nvim/site/parser/"
    success "Treesitter parsers linked"
  else
    info "No system treesitter parsers found, skipping"
  fi
fi

success "Packages installed"

# =============================================================================
# Symlinks
# =============================================================================

info "Creating symlinks..."

# Neovim
mkdir -p "$HOME/.config"
[ -d "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
success "Neovim config linked"

# Zsh
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
success "Zsh config linked"

# Starship
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
success "Starship config linked"

# WezTerm (Mac only)
if [[ "$OS" == "mac" ]]; then
  mkdir -p "$HOME/.config/wezterm"
  ln -sf "$DOTFILES/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
  success "WezTerm config linked"
fi

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
echo ""
