#!/bin/bash
# preset: gruvbox-rainbow
# このコメントのプリセット名を変えると chezmoi が再実行する

# chezmoi 実行時は brew が PATH に入っていないため明示的にロード
if ! command -v starship &>/dev/null; then
  if [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d /opt/homebrew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -d /usr/local/Homebrew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v starship &>/dev/null; then
  echo "starship not installed yet, skipping."
  exit 0
fi

echo "Applying starship preset: gruvbox-rainbow..."
starship preset gruvbox-rainbow -o ~/.config/starship.toml
echo "Done."
