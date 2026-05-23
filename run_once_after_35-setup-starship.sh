#!/bin/bash
# preset: gruvbox-rainbow
# このコメントのプリセット名を変えると chezmoi が再実行する

if ! command -v starship &>/dev/null; then
  echo "starship not installed yet, skipping."
  exit 0
fi

echo "Applying starship preset: gruvbox-rainbow..."
starship preset gruvbox-rainbow -o ~/.config/starship.toml
echo "Done."
