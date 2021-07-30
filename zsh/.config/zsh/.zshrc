HISTSIZE=10000
SAVEHIST=10000
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

# these directories are necessary for zsh.
[[ ! -d ~/.cache/zsh ]] && mkdir -p ~/.cache/zsh
[[ ! -d ~/.local/share/zsh ]] && mkdir -p ~/.local/share/zsh

# Use gpg for ssh authentication
# SOURCES: https://stackoverflow.com/questions/44250002/how-to-solve-sign-and-send-pubkey-signing-failed-agent-refused-operation
#          https://wiki.archlinux.org/title/GnuPG#SSH_agent
gpgconf --launch gpg-agent >/dev/null 2>&1
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

#
# Options
#
setopt APPEND_HISTORY       # don't replace in the hist file
setopt HIST_IGNORE_ALL_DUPS # ignore dups in the hist file
setopt HIST_FIND_NO_DUPS    # don't show dupes when searching
setopt SHARE_HISTORY        # share history across shells
setopt HIST_IGNORE_DUPS     # do filter contiguous duplicates from history

source "$ZDOTDIR/functions"
# prompt
zsh_add_file "prompt.zsh"
# aliases
zsh_add_file "aliasrc"
# Exports
[ -f ~/.zshenv ] && source ~/.zshenv

# Plugins
zsh_add_plugin "zdharma/fast-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "zsh-users/zsh-history-substring-search"
zsh_add_plugin "jeffreytse/zsh-vi-mode"
PLUG_DIR=$ZDOTDIR/plugins
export ZVM_VI_SURROUND_BINDKEY=s-prefix
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
# solves https://github.com/jeffreytse/zsh-vi-mode/issues/90
#        https://github.com/jeffreytse/zsh-vi-mode/issues/24
zvm_after_init() {
    [ -f $PLUG_DIR/fzf/key-bindings.zsh ] && source $PLUG_DIR/fzf/key-bindings.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
}
[ -f $PLUG_DIR/fzf/completion.zsh ] && source $PLUG_DIR/fzf/completion.zsh
[ -f $PLUG_DIR/menu.zsh ] && source $PLUG_DIR/menu.zsh
[ -f $PLUG_DIR/colored-man-pages.zsh ] && source $PLUG_DIR/colored-man-pages.zsh

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
kitty + complete setup zsh | source /dev/stdin
