#!/usr/bin/env bash

set -e

dotfiles_dir="${HOME}/dotfiles"

if [[ $OSTYPE =~ darwin ]]; then
    echo "macOS detected"
    if [ -z "`which brew`" ]; then
        echo "Installing Homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

         brew bundle "${dotfiles_dir}/Brewfile"
    else
        echo "Homebrew is already installed"
    fi
fi

echo "Symlinking configs..."
for file in profile gitconfig vimrc inputrc zshrc; do
    ln -sf "${dotfiles_dir}/${file}" "${HOME}/.${file}"
done
unset file

CURRENT_GIT_USER=`git config --global --get user.name`
CURRENT_GIT_EMAIL=`git config --global --get user.email`
CURRENT_GH_HOST=${GITHUB_HOST:-github.com}

echo "Configuring git..."
read -p "Enter your full name ($CURRENT_GIT_USER): " GIT_USER
read -p "Enter your e-mail ($CURRENT_GIT_EMAIL): " GIT_EMAIL
read -p "Enter your GitHub host ($CURRENT_GH_HOST): " GH_HOST

GIT_USER=${GIT_USER:-$CURRENT_GIT_USER}
GIT_EMAIL=${GIT_EMAIL:-$CURRENT_GIT_EMAIL}
GH_HOST=${GH_HOST:-$CURRENT_GH_HOST}

cat >~/.extra <<EOL
echo "==> Loading .extra"
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

export GITHUB_HOST="${GH_HOST}"
EOL

echo "Done. Reload your shell"
