#!/usr/bin/env bash

set -e

has_command() {
    command -v "$1" > /dev/null 2>&1
}

is_dir() {
    [ -d "$1" ]
}

echo "==> Homebrewをインストール"
if ! has_command brew; then
    # v5.0.3時点
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✓ Homebrewはインストール済み"
fi

echo "==> パッケージをインストール"
brew bundle -v

# EmacsをSpotlightで検索出来るように
echo "==> Emacs.appを配置"
EMACS_PATH="/Applications/Emacs.app"
if ! is_dir $EMACS_PATH; then
    osacompile -o "$EMACS_PATH" -e 'tell application "Finder" to open POSIX file "'"$(brew --prefix)"'/opt/emacs-mac/Emacs.app"'
else
    echo "✓ Emacs.appは配置済み"
fi

echo "==> Doom Emacsをインストール"
DOT_EMACS_D_PATH="$HOME/.emacs.d"
if ! is_dir $DOT_EMACS_D_PATH; then
    # 2025/11/29時点
    git clone https://github.com/hlissner/doom-emacs "$DOT_EMACS_D_PATH"
    "$DOT_EMACS_D_PATH/bin/doom" install
else
    echo "✓ Doom Emacsはインストール済み"
fi

echo "===> fisherをインストール"
if has_command fish && ! fish -c 'type -q fisher'; then
    # fish v4.2.1
    fish -c '
         curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
         fisher install jorgebucaran/fisher
         fisher install oh-my-fish/theme-bobthefish
    '
else
    echo "✓ fisherはインストール済み"
fi

echo "===> 設定ファイルを配置"
stow --adopt -v fish doom vscode
# --adopt での変更を元に戻す
git restore .
