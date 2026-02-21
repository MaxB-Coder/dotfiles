# Dotfiles

Personal development environment configuration for Mac and Windows (WSL).

## Stack

- **Terminal:** WezTerm
- **Shell:** zsh + Starship
- **Editor:** Neovim
- **Theme:** Custom Claude-inspired (charcoal + orange)

---

## Mac Setup

### Prerequisites
- macOS
- Homebrew — if not installed, the install script will install it

### Quick Install
```bash
git clone git@github.com:MaxB-Coder/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

Then open Neovim and run `:Lazy` to install plugins.

### What gets installed

- Neovim with Lazy plugin manager
- WezTerm with custom config
- zsh with Starship prompt
- zsh-autosuggestions and zsh-syntax-highlighting
- ripgrep (for Telescope live grep)
- JetBrains Mono font

### What gets symlinked

| Config | Location |
|--------|----------|
| Neovim | `~/.config/nvim` |
| zsh | `~/.zshrc` |
| Starship | `~/.config/starship.toml` |
| WezTerm | `~/.config/wezterm/wezterm.lua` |

---

## Windows Setup

See [WINDOWS.md](WINDOWS.md) for the full Windows/WSL setup guide.

---

## Structure
```
dotfiles/
├── nvim/
│   ├── init.lua
│   └── lua/
│       ├── claude.lua          # custom Claude theme
│       ├── config/
│       │   ├── options.lua
│       │   ├── keymaps.lua
│       │   └── lazy.lua
│       └── plugins/
│           ├── ui.lua
│           ├── editor.lua
│           ├── lsp.lua
│           ├── treesitter.lua
│           └── dashboard.lua
├── zsh/
│   ├── .zshrc
│   ├── exports.zsh
│   ├── aliases.zsh
│   └── plugins.zsh
├── starship/
│   └── starship.toml
├── wezterm/
│   └── wezterm.lua
├── install.sh
├── README.md
```

---

## Updating

On any machine, pull the latest changes and re-run symlinks:
```bash
cd ~/dotfiles
git pull
```

Plugin updates in Neovim: `:Lazy update`

---

## Key Bindings

### Neovim

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `Space + ff` | Find files |
| `Space + fg` | Search in files |
| `Space + fb` | Find buffers |
| `Space + e` | Toggle file tree |
| `Space + w` | Save file |
| `Space + q` | Quit |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `Space + ca` | Code actions |
| `Space + rn` | Rename symbol |

### WezTerm

| Key | Action |
|-----|--------|
| `CMD + T` | New tab |
| `CMD + W` | Close tab |
| `CMD + 1/2/3` | Switch tab |
| `CMD + M` | Minimise |
| `CMD + Q` | Quit |
| `CMD + Enter` | Toggle fullscreen |
