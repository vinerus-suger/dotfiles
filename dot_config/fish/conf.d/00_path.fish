# ── ローカルバイナリ（chezmoi 等の bootstrap インストール先）────
fish_add_path -g ~/.local/bin

# ── Homebrew PATH ─────────────────────────────
# -g (global) フラグでセッションスコープに限定し、universal variable の汚染を防ぐ。
# conf.d は fish 起動時に毎回読まれるので、毎回 idempotent に PATH が組み立てられる。
# Reference: https://fishshell.com/docs/current/cmds/fish_add_path.html
if test -d /home/linuxbrew/.linuxbrew
    # WSL / Linux
    fish_add_path -g /home/linuxbrew/.linuxbrew/bin
    fish_add_path -g /home/linuxbrew/.linuxbrew/sbin
    set -gx HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
else if test -d /opt/homebrew
    # Mac (Apple Silicon)
    fish_add_path -g /opt/homebrew/bin
    fish_add_path -g /opt/homebrew/sbin
    set -gx HOMEBREW_PREFIX /opt/homebrew
else if test -d /usr/local/Homebrew
    # Mac (Intel)
    fish_add_path -g /usr/local/bin
    fish_add_path -g /usr/local/sbin
    set -gx HOMEBREW_PREFIX /usr/local
end

# Homebrew の fish 補完ディレクトリを fish_complete_path に追加
if set -q HOMEBREW_PREFIX
    set -l completions_dir $HOMEBREW_PREFIX/share/fish/vendor_completions.d
    if test -d $completions_dir
        set -ga fish_complete_path $completions_dir
    end
end
