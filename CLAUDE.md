# CLAUDE.md

このリポジトリは [chezmoi](https://www.chezmoi.io/) で管理された個人dotfiles。

## リポジトリ構成

chezmoi のソースディレクトリがそのままリポジトリルート。
chezmoi の命名規則に従いファイル名が変換される（例: `dot_config/` → `~/.config/`）。

```
dotfiles/
├── dot_config/
│   ├── fish/
│   │   ├── config.fish.tmpl       # メイン設定（chezmoi テンプレート）
│   │   ├── fish_plugins           # fisher プラグインリスト
│   │   └── conf.d/
│   │       ├── 00_path.fish       # PATH・Homebrew 設定
│   │       ├── 10_completion.fish # ツール初期化（mise, zoxide等）
│   │       ├── 20_abbr.fish       # abbreviation 定義
│   │       ├── 30_eza.fish        # eza エイリアス
│   │       ├── 40_fzf.fish        # fzf キーバインド
│   │       └── 50_zoxide.fish     # zoxide 設定
│   ├── wezterm/wezterm.lua.tmpl   # WezTerm 設定（Catppuccin Mocha）
│   ├── helix/                     # Helix エディタ設定
│   ├── lazygit/config.yml
│   ├── jj/config.toml
│   └── mise/config.toml
├── Brewfile                       # 共通パッケージ（Mac/Linux）
├── Brewfile.mac                   # Mac 専用（cask フォント等）
├── run_once_before_10-install-homebrew.sh.tmpl
├── run_onchange_before_20-install-packages.sh.tmpl  # Brewfile 変更時に再実行
├── run_once_after_30-setup-fish.sh.tmpl             # fish をデフォルトシェルに
├── run_once_after_35-setup-starship.sh              # starship preset 適用
├── run_onchange_after_40-setup-wsl-symlinks.sh.tmpl
├── run_onchange_after_50-fisher-sync.sh.tmpl        # fish_plugins 変更時に再実行
├── run_onchange_after_55-setup-gitconfig.sh.tmpl   # git config --global で共通設定を書き込み
└── run_once_after_60-install-bat-themes.sh.tmpl
```

## 重要な設計上のポイント

- **starship の設定は直接ファイル管理しない**。`run_once_after_35-setup-starship.sh` が `starship preset gruvbox-rainbow` コマンドで生成する。プリセットを変えたいときはそのスクリプト冒頭のコメント `# preset: xxx` を書き換える（chezmoi がハッシュ変化を検知して再実行する）。

- **fish プラグインの追加・削除**は `dot_config/fish/fish_plugins` を編集するだけでよい。`run_onchange_after_50-fisher-sync.sh.tmpl` がファイルのハッシュを監視して自動で `fisher update` を実行する。

- **`.gitconfig` は chezmoi で直接管理しない**。ファイルごとコピーする方式だと `[user]` など環境固有の設定を chezmoi が上書きしてしまう問題があったため、delta・alias などの共通設定のみ `run_onchange_after_55-setup-gitconfig.sh.tmpl` が `git config --global` で個別に書き込む方式に変更した。`[user]` などの環境固有設定は各マシンで手動設定する。設定を削除したい場合は `git config --global --unset <key>` で手動対応が必要（スクリプト方式は追加・上書きのみで削除はできないため）。

- **`.tmpl` ファイル**は chezmoi のテンプレート。`{{ if .is_wsl }}` / `{{ if .is_mac }}` で環境分岐している。変数は `.chezmoi.toml.tmpl` で定義。

## Dev Container での注意点

Dev Container 内には git リポジトリが **2つ** 存在する。混同しないこと。

| パス | 用途 |
|------|------|
| `/workspaces/dotfiles作成/dotfiles/` | 開発用ワークスペース（編集・push する場所） |
| `~/.local/share/chezmoi/` | chezmoi が実際に使うソースディレクトリ（GitHub から pull される） |

**Claude（AI）は開発用ワークスペースだけを触ること。** `~/.local/share/chezmoi/` を直接操作すると `chezmoi update` が壊れる原因になる（過去に発生した事例: AI が chezmoi ソースディレクトリで直接ブランチを切り替えたため、削除済みブランチを参照し続けて `chezmoi update` が失敗した）。

### `chezmoi update` が失敗した場合の復旧

```bash
# 原因確認（main 以外のブランチにいたら要修正）
git -C $(chezmoi source-path) branch --show-current

# 修正
git -C $(chezmoi source-path) checkout main
git -C $(chezmoi source-path) pull origin main
```

## ブランチ・PR ルール

このリポジトリは **main への直接 push が禁止**されており、すべての変更は PR 経由でマージする必要がある。また PR には CI（template 検証・shellcheck）のステータスチェックが必須。

変更を加える際は必ず作業ブランチを切り、PR を作成してマージすること。

## 作業フロー

この Dev Container 環境には **`gh` CLI が使用可能**。PR の作成・マージはすべて `gh` コマンドで完結できる。

```bash
# 作業ブランチを切る（必ず main から）
git checkout main && git pull
git checkout -b feat/xxx  # または fix/xxx

# コミット前に必ず現在のブランチを確認する
git branch --show-current

# 編集・コミット・push
git add <files>
git commit -m "feat: ..."
git push -u origin feat/xxx

# PR を作成
gh pr create --title "タイトル" --body "説明"

# CI 通過後に自動マージされるよう設定（推奨）
gh pr merge <PR番号> --merge --auto
# または CI 通過済みであれば即マージ
gh pr merge <PR番号> --merge
```

`--auto` を付けると CI が通り次第自動でマージされる。CI 状況は `gh pr checks <PR番号>` で確認できる。

> **ブランチ間違いに注意**: 複数の作業ブランチを並行して触るときは、コミット前に `git branch --show-current` で現在のブランチを必ず確認すること。間違えた場合は `git revert` で打ち消してから正しいブランチに `git cherry-pick` する。
## 対応環境

- macOS (Apple Silicon / Intel)
- WSL2 (Windows)
- Dev Container (Docker)

## フォント

WezTerm: `HackGen35 Console NF` / `HackGenNerd Console`（ローカルにインストール済み）
VSCode ターミナル: `Monaspace Neon NF`（ローカルにインストール済み）
→ いずれも Nerd Font 対応。Powerline グリフ（セパレータ等）が表示される。
