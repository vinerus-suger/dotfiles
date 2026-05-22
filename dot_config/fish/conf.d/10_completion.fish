# ── 各ツールの初期化・補完登録 ────────────────
# Best practice: status --is-interactive でガードして
# 非インタラクティブシェル（スクリプト経由など）での無駄な初期化を回避

# mise は PATH 操作するためインタラクティブ問わず activate
if command -q mise
    mise activate fish | source
end

# 以下はインタラクティブシェルでのみ必要
status --is-interactive; or return

if command -q starship
    starship init fish | source
end

if command -q zoxide
    zoxide init fish | source
end

# fzf 統合は PatrickF1/fzf.fish プラグインが担当（fish_plugins 参照）
# ※ プラグイン未インストール時のフォールバック
if not functions -q fzf_configure_bindings; and command -q fzf
    fzf --fish | source
end

if command -q chezmoi
    chezmoi completion fish | source
end

if command -q jj
    jj util completion fish | source
end
