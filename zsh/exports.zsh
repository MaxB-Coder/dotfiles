# Editor
export EDITOR="nvim"

# Homebrew prefix (set by `brew shellenv` in ~/.zprofile on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
fi

# Path entries
path=("$HOME/.dotnet/tools" "$HOME/.local/bin" $path)

# Bun
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)

# mise: Node and Go versions from ~/.config/mise/config.toml (in dotfiles),
# or per project from .mise.toml / .nvmrc. Replaces nvm and the manual Go PATH;
# your old nvm installs were imported with `mise sync node --nvm`.
# Uses mise's shims folder rather than `mise activate` (no per-prompt hook,
# ~0ms instead of ~65ms); each shim still picks the version for the folder
# you're in. After `npm install -g`, run `mise reshim` to expose new commands
path=("${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims" $path)

# Java 21 (macOS): find the JDK by path instead of running java_home on
# every shell start
for jdk in /Library/Java/JavaVirtualMachines/*21*.jdk/Contents/Home(N); do
  export JAVA_HOME="$jdk"
  path=("$JAVA_HOME/bin" $path)
  break
done

# Google Cloud SDK (Homebrew cask: gcloud-cli)
GCLOUD_SDK="${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk"
if [ -f "$GCLOUD_SDK/path.zsh.inc" ]; then
  source "$GCLOUD_SDK/path.zsh.inc"
fi
if [ -f "$GCLOUD_SDK/completion.zsh.inc" ]; then
  source "$GCLOUD_SDK/completion.zsh.inc"
fi

# Bun completions (after gcloud, which runs compinit)
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
