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
- A GitHub account with an SSH key configured

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
- A GitHub account

### Step 1: Install WSL

Open PowerShell as Administrator and run:
```powershell
wsl --install
```

Restart your machine when prompted. You may need to restart twice — once to enable the Windows features, and once after Ubuntu installs. When Ubuntu opens, create a username and password.

If Ubuntu doesn't launch automatically after restarting, run:
```powershell
wsl --install -d Ubuntu
```

Verify WSL is working:
```powershell
wsl --list --verbose
```

You should see Ubuntu running with VERSION 2.

### Step 2: Install WezTerm for Windows

Download and install WezTerm from:
https://wezfurlong.org/wezterm/installation.html

Choose the Windows installer (.exe).

### Step 3: Pull WezTerm config from GitHub

In Command Prompt run:
```cmd
mkdir %USERPROFILE%\.config\wezterm
curl -o %USERPROFILE%\.config\wezterm\wezterm.lua https://raw.githubusercontent.com/MaxB-Coder/dotfiles/main/wezterm/wezterm.lua
```

The config automatically detects Windows and points WezTerm at WSL. Restart WezTerm — it should now open Ubuntu.

### Step 4: Install JetBrains Mono Font

Download from:
https://www.jetbrains.com/fonts/

Extract the zip, select all `.ttf` files (ignore webfonts folder), right click and choose **Install for all users**.

### Step 5: Set up SSH and clone dotfiles

Inside WezTerm (now running Ubuntu) run:
```bash
sudo apt-get update
sudo apt-get install -y git

ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
```

Copy the output and add it to GitHub under Settings → SSH Keys → New SSH Key.

**Important:** make sure you are in your Linux home directory before cloning to avoid Windows filesystem performance issues:
```bash
cd ~
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

### Step 8: Install NVM and Node

Mason requires Node for several language servers:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

Close and reopen WezTerm, then:
```bash
nvm install --lts
```

### Step 9: Install additional dependencies
```bash
sudo apt-get install -y unzip python3-pip
```

### Step 10: Install Neovim plugins
```bash
nvim
```

Lazy will automatically install all plugins on first launch.
Wait for it to complete, then press `q` to close the Lazy window.

### Step 11: Verify everything is working
```bash
echo $SHELL        # should return /bin/zsh
echo $EDITOR       # should return nvim
nvim               # should open with Claude theme and dashboard
```

### Notes

- WezTerm config is shared between Mac and Windows via dotfiles. The `wezterm.lua` uses OS detection to automatically set the correct shell — no manual editing needed.
- `plugins.zsh` uses OS detection to source zsh plugins from the correct path on Mac (Homebrew) and Linux (apt).
- Always clone and work inside the Linux filesystem (`~/`) not the Windows filesystem (`/mnt/c/...`) for best performance.
- Windows gaming runs natively and is completely unaffected by WSL.
- To update your dotfiles on either machine: `cd ~/dotfiles && git pull`

### Troubleshooting

**Ubuntu doesn't launch after restart:**
Open PowerShell and run `wsl --install -d Ubuntu`.

**Starship not showing correctly:**
Make sure JetBrains Mono is installed on Windows and set as the font in WezTerm.

**Neovim plugins not installing:**
Make sure Node is in PATH: `node --version`. If not found, install NVM and run `nvm install --lts`.

**Neovim plugins not installing (network):**
Check internet inside WSL: `ping google.com`.
If this fails, restart WSL: run `wsl --shutdown` in PowerShell, then reopen WezTerm.

**zsh not loading .zshrc:**
Make sure the symlink exists: `ls -la ~/.zshrc`
It should point to `~/dotfiles/zsh/.zshrc`.

**Language servers not working:**
Open Neovim and run `:Mason` to check server status. Most issues resolve once Node and pip are installed.

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
