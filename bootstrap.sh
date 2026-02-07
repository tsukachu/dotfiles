#!/usr/bin/env bash

set -e

has_command() {
    command -v "$1" > /dev/null 2>&1
}

is_dir() {
    [ -d "$1" ]
}

echo "==> Homebrew をインストール"
if ! has_command brew; then
    # v5.0.13 時点
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
else
    echo "✓ Homebrew はインストール済み"
fi

echo "==> パッケージをインストール"
brew bundle -v

# divvy が intel 用にビルドされているので必要
echo "==> Rosetta をインストール"
if ! is_dir "/Library/Apple/usr/libexec/oah"; then
   softwareupdate --install-rosetta --agree-to-license
else
   echo "✓ Rosetta はインストール済み"
fi

echo "==> Doom Emacs をインストール"
DOT_EMACS_D_PATH="$HOME/.emacs.d"
if ! is_dir $DOT_EMACS_D_PATH; then
    # 2025/11/29 時点
    git clone https://github.com/hlissner/doom-emacs "$DOT_EMACS_D_PATH"
    "$DOT_EMACS_D_PATH/bin/doom" install
else
    echo "✓ Doom Emacs はインストール済み"
fi

echo "===> fisher をインストール"
if has_command fish && ! fish -c 'type -q fisher'; then
    # fisher v4.4.5 時点
    fish -c '
         curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
         fisher install jorgebucaran/fisher
         fisher install oh-my-fish/theme-bobthefish
    '
else
    echo "✓ fisher はインストール済み"
fi

echo "===> 設定ファイルを配置"
mkdir -p ~/.ssh
stow --adopt -v fish doom ghostty git ssh mise
# --adopt での変更を元に戻す
git restore .
