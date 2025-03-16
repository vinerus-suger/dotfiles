#!/bin/bash

set -eu

# dotfiles のルートディレクトリ（このスクリプトのある場所）
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# リンクを張る関数
link_file() {
    src=$1
    dst=$2

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "🔁 $dst already exists. Backing up to $dst.backup"
        mv "$dst" "$dst.backup"
    fi

    echo "🔗 Linking $src → $dst"
    ln -s "$src" "$dst"
}

# tmux
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

if [ -f "$DOTFILES_DIR/tmux/.tmux.conf.local" ]; then
    link_file "$DOTFILES_DIR/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
fi

echo "✅ tmux dotfiles linked successfully!"
