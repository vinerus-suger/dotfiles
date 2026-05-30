function git-sweep --description "Delete local branches whose remote tracking branch is gone (merged PRs)"
    set -l gone (git branch -vv | grep ': gone]' | awk '{print $1}')

    if test (count $gone) -eq 0
        echo "No gone branches found."
        return 0
    end

    echo "Gone branches:"
    for b in $gone
        echo "  $b"
    end
    echo ""

    # -d（安全削除）で試みる。未マージ扱いのブランチは警告を出してスキップ
    for b in $gone
        if git branch -d $b 2>/dev/null
            echo "✅ deleted $b"
        else
            echo "⚠️  $b: not fully merged locally — skipped (use 'git branch -D $b' to force)"
        end
    end
end
