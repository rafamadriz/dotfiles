#!/bin/sh

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

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

# while answer != [yY] || [nN] do
# read -p "Do you want to contiue ? y/n" answer
# done
print_with_color() {
  printf '%b\n' "$1$2$NORMAL"
}

aur_helper_install() {
  check_net
  directory="tmp"

  info "Installing AUR helper."
  git clone "$1" "$directory" >/dev/null 2>&1
  (cd "$directory" && makepkg -sri --noconfirm) >/dev/null 2>&1
  rm -rf "$directory"
  succces "AUR helper installed."
}

if
  ! [ -f /usr/bin/paru ] &
  ! [ -f /usr/bin/yay ]
then
  info "There isn't any AUR helper installed"

  while true; do
    # (1) prompt user, and read command line argument
    printf "%sWhich one do you want to install ? ${NORMAL}" "${BLUE}"
    printf "\n"
    printf "\t1\tparu "
    printf "\n"
    printf "\t2\tyay "
    printf "\n"
    read -r answer

    # (2) handle the input we were given
    case $answer in
    1*)
      aur_helper_install "https://aur.archlinux.org/paru.git"
      break
      ;;

    2*)
      aur_helper_install "https://aur.archlinux.org/yay.git"
      break
      ;;

    *) error "Dude, just enter 1 or 2, please." ;;
    esac
  done
else
  info ""
fi
