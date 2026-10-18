# Dotfiles

Personal development environment configuration for Mac and Windows (WSL).

## Stack

- **Terminal:** WezTerm, a patched build from [MaxB-Coder/wezterm](https://github.com/MaxB-Coder/wezterm) (full-height tabs, close X on hover, centred traffic lights). Stock WezTerm works too; it skips the patched-only options
- **Configs:** [chezmoi](https://www.chezmoi.io). Everything under `home/` is linked into your home folder, so editing `~/.config/...` edits this repo
- **Shell:** zsh + Starship (pill prompt), fzf, eza, bat, delta, zoxide
- **Editor:** Neovim (snacks.nvim, blink.cmp, conform.nvim, Treesitter `main`)
- **Runtimes:** mise (Node, Go), configured in `home/dot_config/mise/config.toml`
- **Theme:** Gruvbox dark with the Claude orange accent. One palette file, `home/dot_config/wezterm/palette.lua`, is shared by WezTerm and Neovim; Starship and zsh repeat its hex values

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

Everything in [`brew/Brewfile`](brew/Brewfile) (`brew bundle`), then chezmoi puts the configs in place and installs the mise runtimes:

- Neovim with Lazy plugin manager, plus tree-sitter CLI and ripgrep
- JetBrains Mono font
- zsh with Starship, zsh-autosuggestions and zsh-syntax-highlighting
- fzf, eza, bat, git-delta, zoxide
- chezmoi, and mise, which installs Node and Go

WezTerm isn't in the Brewfile: install the patched build (in the fork, `scripts/build-macos-app.sh`, or a release from its CI), or `brew install --cask wezterm` for stock.

`brew/Brewfile.all` is a full snapshot of everything installed on the main Mac (`brew bundle dump`).

Check a machine any time with `./doctor.sh`: tool versions, configs (`chezmoi verify`), git and shell startup time.

### How configs get into place (chezmoi)

chezmoi reads `home/` (set by `.chezmoiroot`) and links each file into your home folder. File names follow chezmoi's naming: `dot_` becomes `.`.

| In the repo | Linked to |
|--------|----------|
| `home/dot_zshrc` | `~/.zshrc` |
| `home/dot_config/zsh/` | `~/.config/zsh/` (sourced by `.zshrc`) |
| `home/dot_config/nvim/` | `~/.config/nvim/` |
| `home/dot_config/starship.toml` | `~/.config/starship.toml` |
| `home/dot_config/wezterm/` | `~/.config/wezterm/` (`wezterm.lua`, `palette.lua`) |
| `home/dot_config/mise/config.toml` | `~/.config/mise/config.toml` |
| `home/dot_config/git/delta.gitconfig` | `~/.config/git/delta.gitconfig` |

On macOS and Linux every file is a symlink back into the repo (`mode = "symlink"` in `home/.chezmoi.toml.tmpl`), so you can edit either `~/.config/...` or `~/dotfiles/home/...` and Lazy's lockfile updates land in git. Native Windows gets plain copies of the WezTerm files only (`home/.chezmoiignore`).

Day to day:

```bash
chezmoi add ~/.config/foo/config.toml   # start tracking a new file
chezmoi status                          # anything out of sync?
chezmoi apply                           # put everything in place again
```

Scripts in `home/.chezmoiscripts` run on apply: one installs the mise runtimes whenever the mise config changes, one adds the delta include to `~/.gitconfig`.

Re-running `install.sh` is safe: chezmoi's links are left alone, links from the old (pre-chezmoi) layout are replaced, and any other file in the way is moved aside with a timestamp.

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

### Step 3: Get the WezTerm config with chezmoi

In PowerShell run:
```powershell
winget install twpayne.chezmoi
chezmoi init --apply MaxB-Coder/dotfiles
```

On Windows chezmoi only installs the WezTerm config (`wezterm.lua` and `palette.lua` in `%USERPROFILE%\.config\wezterm`); the shell and Neovim live in WSL. To update later: `chezmoi update`.

The config automatically detects Windows and points WezTerm at WSL. Restart WezTerm — it should now open Ubuntu.

### Step 4: Install JetBrains Mono Font

Download from:
https://www.jetbrains.com/fonts/

Extract the zip, select all `.ttf` files (ignore the webfonts folder), right click and choose **Install for all users**.

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

### Step 8: Node and Go

Nothing to do: `install.sh` installs mise, which installs Node and Go from `~/.config/mise/config.toml` (Mason needs Node for several language servers). Check with `mise ls`.

### Step 9: Install additional dependencies
```bash
sudo apt-get install -y unzip python3-pip
```

### Step 10: Install Neovim plugins
```bash
nvim
```

Lazy will automatically install all plugins on first launch including Treesitter parsers for all configured languages. Wait for it to complete, then press `q` to close the Lazy window.

### Step 11: Verify everything is working
```bash
echo $SHELL        # should return /bin/zsh
echo $EDITOR       # should return nvim
nvim               # should open with the dashboard
./doctor.sh        # checks tools, versions, links and shell startup
```

### Notes

- WezTerm config is shared between Mac and Windows through chezmoi. `wezterm.lua` uses OS detection to set the right shell and window buttons, and only turns on the patched-build options when the running WezTerm supports them.
- `plugins.zsh` uses OS detection to source zsh plugins from the correct path on Mac (Homebrew) and Linux (apt).
- Always clone and work inside the Linux filesystem (`~/`) not the Windows filesystem (`/mnt/c/...`) for best performance.
- Windows gaming runs natively and is completely unaffected by WSL.
- To update your dotfiles: `cd ~/dotfiles && git pull && chezmoi apply` (WSL, Mac) or `chezmoi update` (Windows).

### Troubleshooting

**Ubuntu doesn't launch after restart:**
Open PowerShell and run `wsl --install -d Ubuntu`.

**Starship not showing correctly:**
Make sure JetBrains Mono is installed on Windows and set as the font in WezTerm.

**Neovim plugins not installing:**
Make sure Node is in PATH: `node --version`. If not found, run `mise install` (and `mise ls` to see what's installed).

**Neovim plugins not installing (network):**
Check internet inside WSL: `ping google.com`.
If this fails, restart WSL: run `wsl --shutdown` in PowerShell, then reopen WezTerm.

**zsh not loading .zshrc:**
Run `chezmoi verify` (silent when everything is in place) or `chezmoi status`, then `chezmoi apply`.
`~/.zshrc` should link to `~/dotfiles/home/dot_zshrc`.

**Language servers not working:**
Open Neovim and run `:Mason` to check server status. Most issues resolve once Node and pip are installed.

**Treesitter highlighting not working:**
The config uses the `main` branch, which needs Neovim 0.12+, `tree-sitter-cli` 0.26.1+ and a C compiler (`install.sh` installs all three). Check with `nvim --version`, `tree-sitter --version`, then run `:TSUpdate`.

---

## Structure
```
dotfiles/
├── .chezmoiroot                # tells chezmoi the configs are in home/
├── home/                       # everything chezmoi puts in ~
│   ├── .chezmoi.toml.tmpl      # per-machine chezmoi settings (symlink mode)
│   ├── .chezmoiignore          # what each OS skips (Windows: all but WezTerm)
│   ├── .chezmoiscripts/        # mise runtimes, git delta include
│   ├── dot_zshrc               # history, completion, prompt
│   └── dot_config/
│       ├── zsh/                # exports, aliases, tools (fzf, bat, zoxide), plugins
│       ├── nvim/
│       │   ├── init.lua
│       │   ├── lazy-lock.json
│       │   └── lua/
│       │       ├── claude.lua      # theme (colours from palette.lua)
│       │       ├── palette.lua     # loads ~/.config/wezterm/palette.lua
│       │       ├── config/         # options, keymaps, lazy
│       │       └── plugins/        # ui, editor, lsp, treesitter, snacks, indent, rainbow
│       ├── wezterm/
│       │   ├── wezterm.lua
│       │   └── palette.lua         # shared colours (WezTerm + Neovim)
│       ├── starship.toml
│       ├── mise/config.toml        # Node, Go versions
│       ├── git/delta.gitconfig
│       └── dot_stylua.toml         # Lua formatting style for ~/.config
├── brew/
│   ├── Brewfile                # what install.sh installs on macOS
│   └── Brewfile.all            # snapshot of everything installed
├── icons/                      # app icon (svg, png, icns, ico)
├── .stylua.toml                # Lua formatting style inside the repo
├── install.sh                  # packages, then chezmoi
├── doctor.sh                   # checks the setup
└── README.md
```

---

## Updating

On macOS and WSL, pull the latest changes and put them in place:
```bash
cd ~/dotfiles
git pull
chezmoi apply
```

On Windows (WezTerm config only): `chezmoi update`.

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
| `Space + fr` | Recent files |
| `Space + fh` | Help |
| `Space + fn` | Notification history |
| `Space + cf` | Format file (also runs on save; `:FormatToggle` turns that off) |
| `gcc` / `gc` | Comment line / selection |
| `Tab` / `Enter` | Next completion / accept |
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
| `CMD + D` | Split pane right |
| `CMD + SHIFT + D` | Split pane down |
| `CMD + OPT + arrows` | Move between panes |
| `CMD + CTRL + arrows` | Resize pane |
| `CMD + SHIFT + Enter` | Zoom pane |
| `CMD + W` | Close pane (and the tab with its last pane) |
| `CMD + 1/2/3` | Switch tab |
| `CMD + SHIFT + R` | Rename tab (empty name resets it) |
| `CMD + SHIFT + P` | Command palette |
| `CMD + M` | Hide WezTerm |
| `CMD + Q` | Quit |
| `CMD + Enter` | Toggle fullscreen |

On Windows these use `CTRL + SHIFT` instead of `CMD` (`CTRL + SHIFT + T`, `CTRL + SHIFT + D`, ...); split down is `CTRL + SHIFT + ALT + D`, and panes move with `CTRL + SHIFT + arrows`.

### Shell

| Key | Action |
|-----|--------|
| `Ctrl + R` | Search command history (fzf) |
| `Ctrl + T` | Find a file and insert its path, with preview |
| `Alt + C` | Jump into a folder |
| `z <name>` | Jump to a folder you've used before (zoxide) |
| `ll` / `tree` | Long listing / tree with icons and git status (eza) |
| `mise use node@22` | Pin a Node version for the current project |
