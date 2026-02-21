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

### Prerequisites
- Windows 10 or 11
- A GitHub account with an SSH key configured

### Step 1: Install WSL

Open PowerShell as Administrator and run:
```powershell
wsl --install
```

This installs WSL2 and Ubuntu by default. Restart your machine when prompted.
Once restarted, Ubuntu will open and ask you to create a username and password.

Verify WSL is working:
```powershell
wsl --list --verbose
```

You should see Ubuntu running with VERSION 2.

### Step 2: Install WezTerm for Windows

Download and install WezTerm from:
https://wezfurlong.org/wezterm/installation.html

Choose the Windows installer (.exe).

### Step 3: Install JetBrains Mono Font

Download from:
https://www.jetbrains.com/legalnotice/fonts/

Install all font files by selecting them all, right clicking and choosing "Install for all users".

### Step 4: Configure WezTerm to use WSL

Open WezTerm's config at `C:\Users\USERNAME\.config\wezterm\wezterm.lua` and update the `default_prog` line to:
```lua
config.default_prog = { "wsl.exe", "--distribution", "Ubuntu" }
```

### Step 5: Clone dotfiles inside WSL

Open WezTerm (it should now open Ubuntu via WSL) and run:
```bash
sudo apt-get update
sudo apt-get install -y git

ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
```

Copy the output and add it to GitHub under Settings → SSH Keys → New SSH Key.

Then clone your dotfiles:
```bash
git clone git@github.com:MaxB-Coder/dotfiles.git ~/dotfiles
```

### Step 6: Install zsh
```bash
sudo apt-get install -y zsh
chsh -s $(which zsh)
```

Close and reopen WezTerm for the shell change to take effect.

### Step 7: Run the install script
```bash
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Step 8: Install Neovim plugins
```bash
nvim
```

Lazy will automatically install all plugins on first launch.
Wait for it to complete, then press `q` to close the Lazy window.

### Step 9: Verify everything is working
```bash
echo $SHELL        # should return /bin/zsh
echo $EDITOR       # should return nvim
nvim               # should open with Claude theme and dashboard
```

### Notes

- WezTerm config is shared between Mac and Windows via dotfiles,
  but the `default_prog` line needs to differ per OS — the wezterm.lua
  already handles this with the OS detection block.
- Windows gaming runs natively and is completely unaffected by WSL.
- To update your dotfiles on either machine: `cd ~/dotfiles && git pull`

### Troubleshooting

**Starship not showing correctly:**
Make sure JetBrains Mono is set as the font in WezTerm settings.

**Neovim plugins not installing:**
Make sure you have an internet connection inside WSL:
```bash
ping google.com
```
If this fails, restart WSL: `wsl --shutdown` in PowerShell, then reopen WezTerm.

**zsh not loading .zshrc:**
Make sure the symlink exists:
```bash
ls -la ~/.zshrc
```
It should point to `~/dotfiles/zsh/.zshrc`.

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
└── README.md
```

---

## Updating

On any machine, pull the latest changes:
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
