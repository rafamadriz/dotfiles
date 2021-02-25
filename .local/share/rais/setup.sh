#!/bin/sh

install="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/install.sh"
user="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/scriptUser.sh"
pkgs_list="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/packages.txt"

mkdir rais && cd rais || exit

for url in $install $user $pkgs_list; do
    curl -OL $url
done

chmod +x install.sh scriptUser.sh
