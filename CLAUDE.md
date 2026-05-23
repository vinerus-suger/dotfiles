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
├── dot_gitconfig.tmpl
├── run_once_before_10-install-homebrew.sh.tmpl
├── run_onchange_before_20-install-packages.sh.tmpl  # Brewfile 変更時に再実行
├── run_once_after_30-setup-fish.sh.tmpl             # fish をデフォルトシェルに
├── run_once_after_35-setup-starship.sh              # starship preset 適用
├── run_onchange_after_40-setup-wsl-symlinks.sh.tmpl
├── run_onchange_after_50-fisher-sync.sh.tmpl        # fish_plugins 変更時に再実行
└── run_once_after_60-install-bat-themes.sh.tmpl
```

## 重要な設計上のポイント

- **starship の設定は直接ファイル管理しない**。`run_once_after_35-setup-starship.sh` が `starship preset gruvbox-rainbow` コマンドで生成する。プリセットを変えたいときはそのスクリプト冒頭のコメント `# preset: xxx` を書き換える（chezmoi がハッシュ変化を検知して再実行する）。

- **fish プラグインの追加・削除**は `dot_config/fish/fish_plugins` を編集するだけでよい。`run_onchange_after_50-fisher-sync.sh.tmpl` がファイルのハッシュを監視して自動で `fisher update` を実行する。

- **`.tmpl` ファイル**は chezmoi のテンプレート。`{{ if .is_wsl }}` / `{{ if .is_mac }}` で環境分岐している。変数は `.chezmoi.toml.tmpl` で定義。

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
# ※ マージ済みブランチは自動削除される設定あり
```

## 対応環境

- macOS (Apple Silicon / Intel)
- WSL2 (Windows)
- Dev Container (Docker)

## フォント

WezTerm: `HackGen35 Console NF` / `HackGenNerd Console`（ローカルにインストール済み）
VSCode ターミナル: `Monaspace Neon NF`（ローカルにインストール済み）
→ いずれも Nerd Font 対応。Powerline グリフ（セパレータ等）が表示される。
