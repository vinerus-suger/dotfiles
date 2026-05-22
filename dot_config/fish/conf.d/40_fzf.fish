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

# Ctrl+R: 履歴検索 / Ctrl+T: ファイル検索 / Alt+C: ディレクトリ移動
# ↑ fzf --fish | source で自動設定される
