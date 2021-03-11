#!/bin/bash

user_does() {
    repo="https://github.com/rafamadriz/dotfiles.git"
    git_dir=".dotfiles"
    dir_tmp=$(mktemp -d)

    # make directory for fonts
    mkdir -p "$HOME"/.local/share/fonts

    # clone repository
    git clone --recurse-submodules --separate-git-dir="$HOME"/$git_dir $repo "$dir_tmp" ;

    # copy all dotfiles to $HOME (this will overwrite any existing destination file)
    rsync --backup --backup-dir="$HOME"/backup --recursive --exclude '.git' "$dir_tmp"/ "$HOME"/ ;
    rm --force --recursive "$dir_tmp" ;

    # git set-up for dotfiles
    function dot {
       /usr/bin/git --git-dir="$HOME"/$git_dir/ --work-tree="$HOME" "$@"
    }
    dot config status.showUntrackedFiles no

    # setting up betterlockscreen
    #betterlockscreen -u "$HOME"/.local/share/wall/firewatch.jpg

    # junegunn/vim-plug for managin plugins
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # install neovim's plugins
    nvim --headless +PlugInstall +qall
}
user_does
