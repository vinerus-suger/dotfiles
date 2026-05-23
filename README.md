# dotfiles

個人開発環境の設定ファイル群。[chezmoi](https://www.chezmoi.io/) で管理。

## 対応環境

- Windows / WSL2
- macOS (Apple Silicon / Intel)
- Dev Container (Docker)

## 初回セットアップ

### Mac / WSL

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply vinerus-suger
```

実行後、Git / jj のユーザー情報を手動で設定してください。

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
jj config set --user user.name  "Your Name"
jj config set --user user.email "you@example.com"
```

### Dev Container

プロジェクトルートに `.devcontainer/` ディレクトリを作成し、以下の 2 ファイルを追加します。

**`.devcontainer/devcontainer.json`**

```json
{
  "name": "Ubuntu",
  "image": "mcr.microsoft.com/devcontainers/base:noble",
  "postCreateCommand": "bash .devcontainer/setup.sh"
}
```

**`.devcontainer/setup.sh`**

```bash
#!/bin/bash
set -euo pipefail

if ! command -v chezmoi >/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply vinerus-suger
fi
```

VS Code で「Reopen in Container」を実行するとコンテナ起動時に `setup.sh` が自動で走り、chezmoi の初期化と設定適用まで完了します。

## ツール構成

| 役割 | ツール |
|---|---|
| dotfiles 管理 | chezmoi |
| シェル | fish |
| プロンプト | Starship |
| ターミナル | WezTerm |
| エディタ | Helix (ruff / pyright / shfmt) |
| Git UI | lazygit |
| Git diff viewer | git-delta |
| VCS | Jujutsu (jj) + lazyjj |
| 言語バージョン管理 | mise |
| Docker TUI | lazydocker |
| ls 代替 | eza |
| cat 代替 | bat (Catppuccin Mocha) |
| cd 代替 | zoxide |
| fuzzy finder | fzf |
| ファイル検索 | fd |
| 高速 grep | ripgrep |
| ディスク使用量 | dust |
| ping グラフ | gping |

## fish プラグイン（fisher）

`dot_config/fish/fish_plugins` で管理。chezmoi が変更を検知すると自動で `fisher update` が走ります。

| プラグイン | 役割 |
|---|---|
| jorgebucaran/fisher | プラグインマネージャー本体 |
| PatrickF1/fzf.fish | fzf による高機能な検索 |
| jorgebucaran/autopair.fish | 括弧・クォートの自動補完 |
| franciscolourenco/done | 長時間コマンド完了時に通知 |
| decors/fish-colored-man | man ページに色付け |
| gazorby/fish-abbreviation-tips | 省略形があるコマンドにヒント表示 |
| meaningful-ooo/sponge | 失敗したコマンドを履歴から除外 |
| oh-my-fish/plugin-foreign-env | bash/zsh の env ファイル読み込み |

## ディレクトリ構成

```
dotfiles/
├── .chezmoi.toml.tmpl       # 環境自動判定＆name/email プロンプト
├── .chezmoiignore
├── .gitignore
├── .github/workflows/test.yml  # CI（template検証・shellcheck）
├── Brewfile                 # 共通CLI（Mac/Linux両対応）
├── Brewfile.mac             # Mac 専用（cask: フォント・GUIアプリ）
├── install.sh               # Dev Container 用ブートストラップ
├── dot_gitconfig.tmpl
├── dot_config/
│   ├── git/ignore           # global gitignore
│   ├── fish/
│   │   ├── config.fish.tmpl
│   │   ├── fish_plugins
│   │   ├── conf.d/00..50_*.fish
│   │   └── functions/dotfiles-doctor.fish
│   ├── starship.toml
│   ├── wezterm/wezterm.lua.tmpl
│   ├── helix/
│   │   ├── config.toml
│   │   └── languages.toml
│   ├── mise/config.toml
│   ├── jj/config.toml
│   └── lazygit/config.yml
├── run_once_before_10-install-homebrew.sh.tmpl     # Homebrew 自身
├── run_onchange_before_20-install-packages.sh.tmpl # Brewfile 変更時に再実行
├── run_once_after_30-setup-fish.sh.tmpl            # fish を default shell に
├── run_onchange_after_40-setup-wsl-symlinks.sh.tmpl # WSL: WezTerm 設定を Windows へコピー（変更時に再実行）
├── run_once_after_60-install-bat-themes.sh.tmpl    # bat: Catppuccin テーマ
├── run_onchange_after_50-fisher-sync.sh.tmpl       # fish_plugins 変更時に再実行
└── .devcontainer/devcontainer.json
```

## 日常運用

```bash
# 設定を編集
chezmoi edit ~/.config/fish/config.fish

# 差分確認
chezmoi diff

# 変更を適用
chezmoi apply

# リポジトリ更新＋適用を一発で
chezmoi update

# ソースに移動して Git 操作
chezmoi cd
git add . && git commit -m "..." && git push

# 健康診断（インストール状況確認）
dotfiles-doctor
```

## セキュリティ

このリポジトリは公開されることを想定しています。**API キー・パスワード・秘密情報は絶対に含めない**でください。秘密情報を扱う場合は chezmoi の [encrypted templates](https://www.chezmoi.io/user-guide/encryption/) や [secret managers](https://www.chezmoi.io/user-guide/password-managers/) を使用してください。
