#!/bin/bash

[[ $(id -u) -eq 0 ]] || { echo >&2 "Must be root to run script"; exit 1; }

echo "============================"
echo "== Installing dotfiles... =="
echo "============================"

# who's the user running the script ?
[ "$SUDO_USER" ] && user=$SUDO_USER || user=$(whoami)

dotscript="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/dotScript.sh"
pkgs_list="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/packages.txt"

for url in $dotscript $pkgs_list; do
    curl -OL $url
done

chmod +x dotScript.sh

pacman -Syy
pacman_install() {
   pacman -S --noconfirm --needed "$pkg"
}

install_aurHelper() {
   directory="tmp"
   aur_repo="https://aur.archlinux.org/paru.git"

   pkg="git"
   pacman_install $pkg
   sudo --user "$user" git clone "$aur_repo" "$directory"
   (cd "$directory" && sudo --user "$user" makepkg -sri --noconfirm)
   rm -rf "$directory"
}

install_dependencies() {
   # Official repositories dependencies
   dependencies=($(sed -n '/name/p' packages.txt | cut -d' ' -f2))
   for pkg in "${dependencies[@]}"; do
      pacman_install "$pkg"
   done

   # AUR dependencies
   dependencies_aur=($(sed -n '/aur/p' packages.txt | cut -d' ' -f2))
   for pkg_aur in "${dependencies_aur[@]}"; do
      sudo --user "$user" paru -S --aur --needed --noconfirm --removemake "$pkg_aur"
   done
}

root_does() {
   install_aurHelper
   install_dependencies

   # Make pacman and paru colorful and adds eye candy on the progress bar.
   grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
   grep -q "^ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

   # run scriptUser
   sudo --user "$user" ./dotScript.sh

   # better root defaults
   [[ ! -d /root/.config/nvim ]] && mkdir -p /root/.config/nvim/colors
   ln -s --force /home/"$user"/.local/share/misc0/root/init.vim /root/.config/nvim/init.vim
   ln -s --force /home/"$user"/.local/share/misc0/root/tender.vim /root/.config/nvim/colors/tender.vim
   ln -s --forece /home/"$user"/.local/share/misc0/root/bashrc /root/.bashrc
   ln -s --forece /home/"$user"/.local/share/misc0/root/bash_profile /root/.bash_profile

   # change shell to zsh
   [ "$(echo "$SHELL")" != "/usr/bin/zsh" ] && chsh -s /usr/bin/zsh "$user"

   rm -f packages.txt dotScript.sh
}
root_does

echo "=========="
echo "== Done =="
echo "=========="
