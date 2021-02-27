#!/bin/bash

user_does() {
    repo="https://github.com/rafamadriz/dotfiles.git"
    git_dir=".dotfiles"
    dir_tmp=$(mktemp -d)

    # make directory for fonts
    mkdir -p "$HOME"/.local/share/fonts

    # clone repository
    git clone --recurse-submodules --separate-git-dir="$HOME"/$git_dir $repo "$dir_tmp" >/dev/null 2>&1;

    # copy all dotfiles to $HOME (this will overwrite any existing destination file)
    rsync --backup --backup-dir="$HOME"/backups --recursive --exclude '.git' "$dir_tmp"/ "$HOME"/ ;
    rm --force --recursive "$dir_tmp" >/dev/null 2>&1;

    # git set-up for dotfiles
    function dot {
       /usr/bin/git --git-dir="$HOME"/$git_dir/ --work-tree="$HOME" "$@"
    }
    dot config status.showUntrackedFiles no

    # setting up betterlockscreen
    betterlockscreen -u "$HOME"/.local/share/wall/firewatch.jpg

    # junegunn/vim-plug for managin plugins
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' >/dev/null 2>&1

    # install neovim's plugins
    nvim --headless +PlugInstall +qall >/dev/null 2>&1
}
user_does
