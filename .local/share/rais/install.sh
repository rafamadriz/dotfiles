#!/bin/bash

[[ $(id -u) -eq 0 ]] || { echo >&2 "Must be root to run script"; exit 1; }

# who's the user running the script ?
[ "$SUDO_USER" ] && user=$SUDO_USER || user=$(whoami)

echo "============================"
echo "== Installing dotfiles... =="
echo "============================"

pacman -Syy
pacman_install() {
   pacman -S --noconfirm --needed "$pkg"
}

install_aurHelper() {
   directory="tmp"
   aur_repo="https://aur.archlinux.org/paru.git"

   pkg="git"
   pacman -Qn git  || pacman_install $pkg
   sudo --user "$user" git clone "$aur_repo" "$directory"
   (cd "$directory" && sudo --user "$user" makepkg -sri --noconfirm)
   rm -rf "$directory"
}

install_depencies() {
   # Official repositories dependencies
   dependencies=($(sed -n '/name/p' packages.txt | cut -d' ' -f2))
   for pkg in "${dependencies[@]}"; do
      pacman -Qn "$pkg" || pacman_install "$pkg"
   done

   # AUR dependencies
   dependencies_aur=($(sed -n '/name/p' packages.txt | cut -d' ' -f2))
   for pkg_aur in "${dependencies_aur[@]}"; do
      pacman -Qm "$pkg_aur" || sudo --user "$user" paru -S --aur --needed --noconfirm --removemake "$pkg_aur"
   done
}

root_does() {
   install_aurHelper
   install_depencies

   # Make pacman and paru colorful and adds eye candy on the progress bar.
   grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
   grep -q "^ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
}
root_does

# run scriptUser
sudo --user "$user" ./scriptUser.sh

# vimrc config for root user.
# Useful to have some nice vim defaults when editing files as root
ln -s --force /home/"$user"/.local/share/misc0/vimrc /root/.vimrc

# change shell to zsh
[ "$(echo "$SHELL")" != "/usr/bin/zsh" ] && chsh -s /usr/bin/zsh "$user"

echo "=========="
echo "== Done =="
echo "=========="