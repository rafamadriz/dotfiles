#!/bin/sh
# Rafael's Auto Install Script (RAIS)
# By Rafael Madriz

# Some colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Messages
error() {
  printf "${BOLD}${RED}[✘] %s${NORMAL}\n" "$@" >&2
}

info() {
  printf "${BOLD}${BLUE}[➭] %s${NORMAL}\n" "$@" >&2
}

warn() {
  printf "${BOLD}${YELLOW}[⚠] %s${NORMAL}\n" "$@" >&2
}

succces() {
  printf "${BOLD}${GREEN}[✔] %s${NORMAL}\n" "$@" >&2
}

print_with_color() {
  printf '%b\n' "$1$2$NORMAL"
}

if [ "$(id -u)" = 0 ]; then
  error "Do not run this script as root or using sudo."
  exit 1
fi

get_pkg_list() {
  pkgs_list="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/packages.yml"
  info "Getting list of dependencies to install"
  curl -OL $pkgs_list >/dev/null 2>&1
}

# Utils
wait_sudo() {
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

check_net() {
  ping -q -c 1 example.org >/dev/null || error "Check your network connection." exit
}

sync() {
  warn "sudo password is needed for installind dependencies."
  info "Sycning repositories."
  sudo pacman -Syy >/dev/null 2>&1 || exit
}

pacman_install() {
  sudo pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1
}

aur_install() {
  paru -S --aur --noconfirm --removemake --needed "$pkg_aur" >/dev/null 2>&1
}

install_depend() {
  check_net
  sync

  info "Installing dependencies from official repository."
  dependencies=$(sed -n 's/^[ \t]*//;/name/p' ./packages.yml | cut -d' ' -f2)
  for pkg in ${dependencies}; do
    pacman_install "$pkg" || error "Something went wrong during installation." exit
  done
  succces "Dependencies from official repository have been installed."
}

aur_helper_install() {
  check_net
  aur_repo="https://aur.archlinux.org/paru.git"
  directory="tmp"

  info "Installing AUR helper."
  git clone "$aur_repo" "$directory" >/dev/null 2>&1
  (cd "$directory" && makepkg -sri --noconfirm) >/dev/null 2>&1
  rm -rf "$directory"
  succces "AUR helper installed."
}

aur_depend() {
  check_net

  info "Installing dependencies from AUR repository."
  dependencies_aur=$(sed -n 's/^[ \t]*//;/aur/p' ./packages.yml | cut -d' ' -f2)
  for pkg_aur in ${dependencies_aur}; do
    aur_install "$pkg_aur" || error "Something went wrong during installation." exit
  done
  succces "Dependencies from AUR repository have been installed."
}

setup_dotfiles() {
  check_net

  git_dir="dotfiles"
  dotfiles="https://github.com/rafamadriz/dotfiles.git"
  dir_tmp="tmp"

  # make directory
  mkdir -p "$HOME"/.local/share/fonts

  # clone repository
  info "Installing Dotfiles"
  git clone --recurse-submodules --separate-git-dir="$HOME"/$git_dir $dotfiles "$dir_tmp" >/dev/null 2>&1 ||
    error "Something went wrong downloading dotfiles" exit

  # copy all dotfiles to $HOME (this will overwrite any existing destination file)
  rsync --recursive --exclude '.git' "$dir_tmp"/ "$HOME"/
  rm --force --recursive "$dir_tmp"
  rm --force --recursive "$git_dir"
  succces "Dotfiles have been installed"

  # setting up betterlockscreen
  #betterlockscreen -u "$HOME"/.local/share/wall/firewatch.jpg
}

final_touches() {
  info "Almost done, some final settings :)"
  # Make pacman and paru colorful and adds eye candy on the progress bar.
  su root -c 'grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf'
  su root -c 'grep -q "^ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf'

  # better root defaults
  [ ! -d /root/.config/nvim ] && sudo mkdir -p /root/.config/nvim/colors
  sudo ln -s --force "$HOME"/.local/share/misc/root/init.vim /root/.config/nvim/init.vim
  sudo ln -s --force "$HOME"/.local/share/misc/root/tender.vim /root/.config/nvim/colors/tender.vim
  sudo ln -s --force "$HOME"/.local/share/misc/root/bashrc /root/.bashrc
  sudo ln -s --force "$HOME"/.local/share/misc/root/bash_profile /root/.bash_profile
  rm -f ./packages.yml

  # change shell to zsh
  info "Changing shell to zsh."
  [ "$SHELL" != "/usr/bin/zsh" ] && chsh -s /usr/bin/zsh
}

printf "\n"
print_with_color "${BLUE}" "      ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
print_with_color "${BLUE}" "      ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
print_with_color "${BLUE}" "      ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
print_with_color "${BLUE}" "      ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
print_with_color "${BLUE}" "      ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
print_with_color "${BLUE}" "      ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
print_with_color "${BLUE}" "       by Rafael Madriz    https://github.com/rafamadriz/dotfiles  "
printf "\n"

warn "This script may overwrite files that you don’t want to be overwritten!"
while true; do
  # (1) prompt user, and read command line argument
  printf "%sDo you want to continue ?[y/n] ${NORMAL}" "${YELLOW}"
  read -r answer

  # (2) handle the input we were given
  case $answer in
  [yY]*)

    get_pkg_list
    install_depend
    wait_sudo
    aur_helper_install
    aur_depend
    setup_dotfiles
    final_touches

    break
    ;;

  [nN]*) exit ;;

  *) error "Dude, just enter Y or N, please." ;;
  esac
done
