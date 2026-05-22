#!/bin/bash
set -e

# chezmoi がなければインストール
if ! command -v chezmoi &>/dev/null; then
  echo "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "Running chezmoi init --apply..."
chezmoi init --apply --source ~/dotfiles

echo "Done!"
