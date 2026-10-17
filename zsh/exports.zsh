# Editor
export EDITOR="nvim"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Path entries
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Google Cloud SDK (Homebrew cask: gcloud-cli)
GCLOUD_SDK="${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk"
if [ -f "$GCLOUD_SDK/path.zsh.inc" ]; then
  source "$GCLOUD_SDK/path.zsh.inc"
fi
if [ -f "$GCLOUD_SDK/completion.zsh.inc" ]; then
  source "$GCLOUD_SDK/completion.zsh.inc"
fi
