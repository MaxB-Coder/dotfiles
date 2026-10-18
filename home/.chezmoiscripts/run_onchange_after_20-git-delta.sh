#!/bin/bash
# Send git diffs through delta by adding one include line to ~/.gitconfig
# (the rest of ~/.gitconfig stays yours). Skipped without delta, since git
# can't page through a missing program. Also removes the include path used
# before the move to chezmoi
new="~/.config/git/delta.gitconfig"
if git config --global --get-all include.path | grep -qxF "~/dotfiles/git/delta.gitconfig"; then
  git config --global --unset-all include.path '^~/dotfiles/git/delta\.gitconfig$'
fi
if ! command -v delta >/dev/null 2>&1; then
  echo "delta not installed, git keeps its normal diff view"
  exit 0
fi
if ! git config --global --get-all include.path | grep -qxF "$new"; then
  git config --global --add include.path "$new"
fi
