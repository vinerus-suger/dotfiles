function dotfiles-doctor --description "Check dotfiles installation status (Mac / Linux / WSL)"
    # ── Platform detection ─────────────────────────
    set -l platform "Unknown"
    set -l platform_detail ""

    if test -n "$WSL_DISTRO_NAME"
        set platform "WSL"
        set platform_detail " ($WSL_DISTRO_NAME)"
    else
        switch (uname)
            case Darwin
                set platform "macOS"
                set platform_detail " ("(uname -m)")"
            case Linux
                set platform "Linux"
                set platform_detail " ("(uname -m)")"
        end
    end

    echo "🖥️  Platform: $platform$platform_detail"
    echo "🐟 Shell:    $SHELL"
    echo ""

    # ── Common tool checks ─────────────────────────
    # 形式: "section|表示名|コマンド名"
    set -l checks \
        "Shell & Prompt|fish|fish"                  \
        "Shell & Prompt|starship|starship"          \
        "Shell & Prompt|fisher|fisher"              \
        "dotfiles manager|chezmoi|chezmoi"          \
        "Git / VCS|git|git"                         \
        "Git / VCS|delta|delta"                     \
        "Git / VCS|lazygit|lazygit"                 \
        "Git / VCS|jj|jj"                           \
        "Git / VCS|lazyjj|lazyjj"                   \
        "CLI tools|eza|eza"                         \
        "CLI tools|bat|bat"                         \
        "CLI tools|zoxide|zoxide"                   \
        "CLI tools|fzf|fzf"                         \
        "CLI tools|fd|fd"                           \
        "CLI tools|ripgrep|rg"                      \
        "CLI tools|dust|dust"                       \
        "Editor & LSP|helix|hx"                     \
        "Editor & LSP|ruff|ruff"                    \
        "Editor & LSP|pyright|pyright-langserver"   \
        "Editor & LSP|shfmt|shfmt"                  \
        "Editor & LSP|marksman|marksman"            \
        "Editor & LSP|prettier|prettier"            \
        "Version managers|mise|mise"                \
        "Docker|lazydocker|lazydocker"              \
        "データサイエンス / ML|jq|jq"               \
        "データサイエンス / ML|uv|uv"               \
        "データサイエンス / ML|git-lfs|git-lfs"

    set -l ok 0
    set -l ng 0
    set -l prev_section ""

    for entry in $checks
        set -l parts   (string split "|" $entry)
        set -l section $parts[1]
        set -l name    $parts[2]
        set -l cmd     $parts[3]

        if test "$section" != "$prev_section"
            test -n "$prev_section"; and echo ""
            echo "── $section ──"
            set prev_section $section
        end

        # fisher は fish 関数なので command -q では検出できない。type -q はオートロードパスも検索する
        if test "$cmd" = fisher
            if type -q fisher
                echo "✅ $name (~/.config/fish/functions/fisher.fish)"
                set ok (math $ok + 1)
            else
                echo "❌ $name (not installed)"
                set ng (math $ng + 1)
            end
        else if command -q $cmd
            echo "✅ $name ("(command -v $cmd)")"
            set ok (math $ok + 1)
        else
            echo "❌ $name (not installed)"
            set ng (math $ng + 1)
        end
    end

    # ── Git config ─────────────────────────────────
    echo ""
    echo "── Git config ──"
    set -l git_name  (git config --global user.name  2>/dev/null)
    set -l git_email (git config --global user.email 2>/dev/null)
    if test -n "$git_name"; and test -n "$git_email"
        echo "✅ git user: $git_name <$git_email>"
        set ok (math $ok + 1)
    else
        echo "❌ git user not configured"
        set ng (math $ng + 1)
    end

    # ── Default shell ──────────────────────────────
    echo ""
    echo "── Default shell ──"
    set -l fish_path (command -v fish 2>/dev/null)
    if test "$SHELL" = "$fish_path"
        echo "✅ default shell is fish ($fish_path)"
    else if test -n "$REMOTE_CONTAINERS"; or test -n "$CODESPACES"
        echo "ℹ️  default shell: bash → fish (auto-exec via .bashrc, expected in DevContainer)"
    else
        echo "⚠️  default shell: $SHELL (expected: $fish_path)"
    end

    # ── Platform-specific checks ───────────────────
    switch $platform
        case macOS
            echo ""
            echo "── macOS-specific ──"
            # Homebrew prefix
            if test -d /opt/homebrew
                echo "✅ Homebrew (Apple Silicon): /opt/homebrew"
            else if test -d /usr/local/Homebrew
                echo "✅ Homebrew (Intel): /usr/local"
            else
                echo "❌ Homebrew not found"
                set ng (math $ng + 1)
            end
            # WezTerm app
            if test -d /Applications/WezTerm.app
                echo "✅ WezTerm.app installed"
            else
                echo "⚠️  WezTerm.app not in /Applications"
            end
            # Fonts (Library/Fonts に HackGen が入ってるか)
            if count (find ~/Library/Fonts /Library/Fonts -maxdepth 1 -iname "*HackGen*" 2>/dev/null) > /dev/null
                echo "✅ HackGen font installed"
            else
                echo "⚠️  HackGen font not found (brew install --cask font-hackgen-nerd)"
            end

        case WSL
            echo ""
            echo "── WSL-specific ──"
            # Windows interop ＋ ユーザーフォルダ・WezTerm同期チェック
            if command -q cmd.exe
                echo "✅ Windows interop (cmd.exe) available"
                set -l win_home_raw (cmd.exe /c echo %USERPROFILE% 2>/dev/null | tr -d '\r')
                if test -n "$win_home_raw"
                    set -l win_home (wslpath "$win_home_raw" 2>/dev/null)
                    if test -d "$win_home"
                        echo "✅ Windows user folder accessible: $win_home"
                        if test -f "$win_home/.config/wezterm/wezterm.lua"
                            echo "✅ WezTerm config synced to Windows side"
                        else
                            echo "⚠️  WezTerm config NOT synced to Windows side"
                            echo "    → Run: chezmoi apply"
                        end
                    else
                        echo "⚠️  Windows user folder not accessible"
                    end
                end
            else
                echo "❌ Windows interop not available"
                set ng (math $ng + 1)
            end
            # Linuxbrew
            if test -d /home/linuxbrew/.linuxbrew
                echo "✅ Linuxbrew: /home/linuxbrew/.linuxbrew"
            else
                echo "❌ Linuxbrew not installed"
                set ng (math $ng + 1)
            end

        case Linux
            echo ""
            echo "── Linux-specific ──"
            # DevContainer detection
            if test -n "$REMOTE_CONTAINERS"; or test -n "$CODESPACES"
                echo "ℹ️  Running in DevContainer / Codespaces"
            end
            # Linuxbrew
            if test -d /home/linuxbrew/.linuxbrew
                echo "✅ Linuxbrew: /home/linuxbrew/.linuxbrew"
            else
                echo "⚠️  Linuxbrew not installed"
            end
    end

    # ── chezmoi state ──────────────────────────────
    echo ""
    echo "── chezmoi state ──"
    if command -q chezmoi
        set -l src_dir (chezmoi source-path 2>/dev/null)
        if test -n "$src_dir"
            echo "✅ source dir: $src_dir"
            set -l diff_output (chezmoi diff 2>/dev/null)
            set -l diff_status $status
            if test $diff_status -ne 0
                echo "⚠️  chezmoi diff failed (run: chezmoi doctor)"
            else if test (count $diff_output) -eq 0
                echo "✅ no pending changes"
            else
                echo "⚠️  pending changes ("(count $diff_output)" lines, run: chezmoi diff)"
            end
        else
            echo "⚠️  chezmoi not initialized (run: chezmoi init)"
        end
    else
        echo "❌ chezmoi not installed"
    end

    # ── Summary ────────────────────────────────────
    echo ""
    echo "──────────────────────────────────────"
    echo "OK: $ok   NG: $ng"
    if test $ng -gt 0
        echo "→ Run: chezmoi apply"
        return 1
    end
end
