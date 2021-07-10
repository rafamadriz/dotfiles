#!/bin/sh
# By Rafael Madriz

# colors
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

success() {
    printf "${BOLD}${GREEN}[✔] %s${NORMAL}\n" "$@" >&2
}

print_with_color() {
    printf '%b\n' "$1$2$NORMAL"
}

need_cmd() {
    if ! hash "$1" >/dev/null; then
        error "Need '$1' (command not found)"
        exit 1
    fi
}

install_packer() {
    info "Install packer.nvim"
    pack_path="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    if [ ! -d "$pack_path" ]; then
        git clone https://github.com/wbthomason/packer.nvim "$pack_path" >/dev/null 2>&1
        success "packer.nvim installation done"
    else
        info "packer.nvim is already installed"
    fi
}

check_nvim_config() {
    if [ -d "$HOME/.config/nvim" ]; then
        error "First backup your nvim folder located at $HOME/.config/nvim"
        info "You can backup your nvim configuration by executing the following command:"
        print_with_color "$YELLOW" "\tmv ~/.config/nvim ~/.config/nvim_back"
        exit 0
    fi
}

install() {
    check_nvim_config
    info "Cloning NeonVim configuration"
    if git clone https://github.com/rafamadriz/NeonVim.git "$HOME/.config/nvim" >/dev/null 2>&1; then
        success "Successfully clone"
        nvim +PackerSync
    else
        error "Failed to clone"
        exit 0
    fi
}

check_requirements() {
    info "Checking requirements"
    if hash "nvim" >/dev/null; then
        info "Neovim version needs to be v0.5.0 or above"
        print_with_color "$YELLOW" "Your Neovim version is: $(nvim --version | sed '1q' | awk '{print $2}')"
    else
        error "Check requirements: nvim"
        exit 0
    fi
    if hash "node" >/dev/null; then
        success "Check requirements: node"
    else
        warn "Check requirements: node (optional, required to use LSP)"
    fi
    if hash "npm" >/dev/null; then
        success "Check requirements: npm"
    else
        warn "Check requirements: npm (optional, required to use LSP)"
    fi
    if hash "pip3" >/dev/null; then
        success "Check requirements: pip3"
    else
        warn "Check requirements: pip3 (optional)"
    fi
}

main() {
    if [ $# -gt 0 ]; then
        case $1 in
        --check-requirements | -c)
            check_requirements
            exit 0
            ;;
        --install | -i)
            need_cmd 'git'
            check_requirements
            install_packer
            install
            exit 0
            ;;
        esac
    else
        need_cmd 'git'
        check_requirements
        install_packer
        install
    fi
}

main "$@"
