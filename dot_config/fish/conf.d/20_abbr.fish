# ── eza（ls 代替）────────────────────────────
abbr -a ls  'eza --icons=always'
abbr -a ll  'eza -lah --icons=always --git'
abbr -a lt  'eza --tree --icons=always -L 2'
abbr -a la  'eza -a --icons=always'

# ── bat（cat 代替）───────────────────────────
abbr -a cat 'bat'

# ── TUI ──────────────────────────────────────
abbr -a lg  'lazygit'
abbr -a ld  'lazydocker'
abbr -a lj  'lazyjj'

# ── Jujutsu ──────────────────────────────────
abbr -a jjl  'jj log'
abbr -a jjs  'jj status'
abbr -a jjd  'jj diff'
abbr -a jjn  'jj new'
abbr -a jji  'jj git init --colocate'
abbr -a jjp  'jj git push'
abbr -a jjf  'jj git fetch'

# ── chezmoi ──────────────────────────────────
abbr -a cz   'chezmoi'
abbr -a cza  'chezmoi apply'
abbr -a czd  'chezmoi diff'
abbr -a cze  'chezmoi edit'
abbr -a czu  'chezmoi update'
abbr -a czcd 'chezmoi cd'

# ── データサイエンス / ML ──────────────────────
abbr -a j    'just'

# ── ナビゲーション ────────────────────────────
abbr -a ..    'cd ..'
abbr -a ...   'cd ../..'
abbr -a ....  'cd ../../..'
abbr -a du    'dust'
