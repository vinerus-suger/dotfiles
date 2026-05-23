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

## ブランチ・PR ルール

このリポジトリは **main への直接 push が禁止**されており、すべての変更は PR 経由でマージする必要がある。また PR には CI（template 検証・shellcheck）のステータスチェックが必須。

変更を加える際は必ず作業ブランチを切り、PR を作成してマージすること。

## 作業フロー

```bash
# 作業ブランチを切る（必ず main から）
git checkout main && git pull
git checkout -b feat/xxx  # または fix/xxx

# 編集・コミット・push
git add <files>
git commit -m "feat: ..."
git push -u origin feat/xxx

# GitHub で PR を作成してマージ
gh pr create
```

## 対応環境

- macOS (Apple Silicon / Intel)
- WSL2 (Windows)
- Dev Container (Docker)

## フォント

WezTerm: `HackGen35 Console NF` / `HackGenNerd Console`（ローカルにインストール済み）
VSCode ターミナル: `Monaspace Neon NF`（ローカルにインストール済み）
→ いずれも Nerd Font 対応。Powerline グリフ（セパレータ等）が表示される。
