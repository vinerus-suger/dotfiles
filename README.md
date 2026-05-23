# dotfiles

個人開発環境の設定ファイル群。[chezmoi](https://www.chezmoi.io/) で管理。

## 対応環境

- Windows / WSL2
- macOS (Apple Silicon / Intel)
- Dev Container (Docker)

## このdotfilesを適用すると何ができるか

### ワンコマンドで環境が揃う

`chezmoi init --apply` 一発で Homebrew のインストール → パッケージ導入 → fish をデフォルトシェルに変更 → 各ツールの設定適用まで自動で完了します。新しいマシンや Dev Container でも同じ環境が数分で再現できます。

### ターミナル操作が速くなる

| やりたいこと | 操作 |
|---|---|
| よく使うディレクトリへ一発移動 | `cd proj` → zoxide が履歴から学習して補完 |
| インタラクティブにディレクトリ選択 | `cdi`（fzf が起動） |
| コマンド履歴をあいまい検索 | `Ctrl+R`（fzf.fish） |
| ファイルをあいまい検索 | `Ctrl+F`（fzf.fish、バックエンドは fd） |

### 組み込みコマンドが強化版に置き換わる

```fish
ls    # → eza（アイコン付き）
ll    # → eza -lah --git（Gitの変更状態も表示）
lt    # → eza --tree -L 2（ツリー表示）
cat   # → bat（シンタックスハイライト、Catppuccin Mocha）
du    # → dust（ディスク使用量をビジュアル表示）
```

### Gitワークフローが快適になる

```fish
lg    # lazygit を起動（TUIでステージ・コミット・プッシュを一括操作）
lj    # lazyjj を起動（Jujutsu の TUI）

# git diff が delta で色付き表示（行内差分・シンタックスハイライト付き）
git diff

# Jujutsu 略語
jjl   # jj log
jjs   # jj status
jjd   # jj diff
jjp   # jj git push
```

### chezmoi の操作が略語で素早くできる

```fish
cza   # chezmoi apply  （設定を反映）
czd   # chezmoi diff   （差分確認）
cze   # chezmoi edit   （設定ファイルを編集）
czu   # chezmoi update （リポジトリ更新＋適用を一発で）
czcd  # chezmoi cd     （ソースディレクトリへ移動）
```

### Helix エディタで LSP 補完が動く

インストール直後から以下の言語で補完・診断・フォーマットが使えます。

| 言語 | LSP / フォーマッタ |
|---|---|
| Python | pyright（型補完）+ ruff（linting / format） |
| Shell | shfmt（フォーマット） |
| Markdown | marksman（リンク補完）+ prettier（フォーマット） |

設定済みの Helix テーマは Catppuccin Mocha。相対行番号・インデントガイド・インレイヒント・ソフトラップも有効。

### fish プラグインを追加するだけで自動同期される

`dot_config/fish/fish_plugins` にプラグイン名を書くと、chezmoi がファイルの変更を検知して自動で `fisher update` を実行します。手動で `fisher install` を叩く必要はありません。

### 環境ごとに設定が自動分岐する

chezmoi テンプレートで環境を判定し、WSL・macOS・Linux で異なる設定を自動適用します。

- **WSL**: WezTerm の設定ファイルを Windows 側へ自動シンボリックリンク
- **macOS**: `Brewfile.mac` の cask（フォント・GUI アプリ）を追加インストール

### 言語バージョンを mise で一元管理

mise を使って Python / Node.js / Ruby などをプロジェクトごとに切り替えられます。`.mise.toml` をリポジトリに置くだけでバージョンが固定されます。

### 環境の健康診断ができる

```fish
dotfiles-doctor  # 全ツールのインストール状況を一覧表示
```

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
