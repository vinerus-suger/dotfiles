# ── fzf 設定 ─────────────────────────────────
# fd をファイル検索バックエンドに使用
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'

# Catppuccin Mocha カラースキーム
set -gx FZF_DEFAULT_OPTS "\
  --height 40% \
  --layout=reverse \
  --border \
  --color=bg+:#313244,bg:#1e1e2e \
  --color=spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8 \
  --color=info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4 \
  --color=prompt:#cba6f7,hl+:#f38ba8"

# fzf.fish キーバインド（デフォルトから Ctrl+T をディレクトリ検索に割り当て）
# Ctrl+T: ディレクトリ検索, Ctrl+R: 履歴, Ctrl+Alt+S: git status
if type -q fzf_configure_bindings
    fzf_configure_bindings --directory=ctrl-t
end
