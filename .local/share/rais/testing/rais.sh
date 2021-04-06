#!/bin/sh
# Rafael's Auto Install Script (RAIS)
# By Rafael Madriz

# Some colors
# BLACK=$(tput setaf 0)
# LIME_YELLOW=$(tput setaf 190)
# POWDER_BLUE=$(tput setaf 153)
# MAGENTA=$(tput setaf 5)
# CYAN=$(tput setaf 6)
# WHITE=$(tput setaf 7)
# BLINK=$(tput blink)
# REVERSE=$(tput smso)
# UNDERLINE=$(tput smul)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Messages
error() {
  printf "${BOLD}${RED}[ERROR] %s${NORMAL}\n" "$@" >&2
}

info() {
  printf "${BOLD}${BLUE}[INFO] %s${NORMAL}\n" "$@" >&2
}

warn() {
  printf "${BOLD}${YELLOW}[WARNING] %s${NORMAL}\n" "$@" >&2
}

succces() {
  printf "${BOLD}${GREEN}[SUCESS] %s${NORMAL}\n" "$@" >&2
}

if [ "$(id -u)" = 0 ]; then
  error "Do not run this script as root or using sudo."
  exit 1
fi

get_pkg_list() {
  pkgs_list="https://raw.githubusercontent.com/rafamadriz/dotfiles/main/.local/share/rais/packages.yml"
  info "Getting list of dependencies to install"
  curl -OL $pkgs_list
}
get_pkg_list

# Variables
dependencies=$(sed -n 's/^[ \t]*//;/name/p' ./packages.yml | cut -d' ' -f2)
dependencies_aur=$(sed -n 's/^[ \t]*//;/aur/p' ./packages.yml | cut -d' ' -f2)
aur_repo="https://aur.archlinux.org/paru.git"
dotfiles="https://github.com/rafamadriz/dotfiles.git"

# Utils
wait() {
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

check_net() {
  ping -q -c 1 example.org >/dev/null || error "Check your network connection" exit
}

sync() {
  warn "sudo password is needed for installind dependencies"
  info "Sycning repositories"
  wait
  sudo pacman -Syy || exit
}

pacman_install() {
  sudo pacman -S --noconfirm --needed "$pkg"
}

aur_install() {
  paru -S --aur --noconfirm --removemake --needed "$pkg"
}

install_depend() {
  check_net
  sync

  info "Installing dependencies from official repository"
  for pkg in ${dependencies}; do
    pacman_install "$pkg" || error "Something went wrong during installation" exit
  done
  succces "Dependencies from official repository have been installed"
}

aur_helper_install() {
  check_net
  directory="tmp"

  git clone "$aur_repo" "$directory"
  (cd "$directory" && makepkg -sri --noconfirm)
  rm -rf "$directory"
  succces "Dependencies from AUR repository have been installed"
}

aur_depend() {
  check_net

  info "Installing dependencies from AUR repository "
  for pkg_aur in ${dependencies_aur}; do
    aur_install "$pkg_aur" || error "Something went wrong during installation" exit
  done
}

setup_dotfiles() {
  check_net

  info "Installing Dotfiles"
  git_dir="dotfiles"
  dir_tmp="tmp"

  # make directory
  mkdir -p "$HOME"/.config
  mkdir -p "$HOME"/.local/share/fonts

  # clone repository
  git clone --recurse-submodules --separate-git-dir="$HOME"/.config/$git_dir $dotfiles "$dir_tmp"

  # copy all dotfiles to $HOME (this will overwrite any existing destination file)
  mkdir "$HOME"/backup
  rsync --backup --backup-dir="$HOME"/backup --recursive --exclude '.git' "$dir_tmp"/ "$HOME"/
  rm --force --recursive "$dir_tmp"

  # git set-up for dotfiles
  dot() {
    /usr/bin/git --git-dir="$HOME"/$git_dir/ --work-tree="$HOME" "$@"
  }
  dot config status.showUntrackedFiles no

  # setting up betterlockscreen
  #betterlockscreen -u "$HOME"/.local/share/wall/firewatch.jpg
}

final_touches() {
  info "Almost done, some final settings :)"
  # Make pacman and paru colorful and adds eye candy on the progress bar.
  sudo grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
  sudo grep -q "^ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

  # better root defaults
  [ ! -d /root/.config/nvim ] && sudo mkdir -p /root/.config/nvim/colors
  sudo ln -s --force "$HOME"/.local/share/misc/root/init.vim /root/.config/nvim/init.vim
  sudo ln -s --force "$HOME"/.local/share/misc/root/tender.vim /root/.config/nvim/colors/tender.vim
  sudo ln -s --force "$HOME"/.local/share/misc/root/bashrc /root/.bashrc
  sudo ln -s --force "$HOME"/.local/share/misc/root/bash_profile /root/.bash_profile
  rm -f ./packages.yml

  # change shell to zsh
  [ "$SHELL" != "/usr/bin/zsh" ] && chsh -s /usr/bin/zsh
}

install_depend
aur_helper_install
aur_depend
setup_dotfiles
final_touches
