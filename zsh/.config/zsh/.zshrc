HISTSIZE=10000
SAVEHIST=10000
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
kitty + complete setup zsh | source /dev/stdin

# these directories are necessary for zsh.
[[ ! -d ~/.cache/zsh ]] && mkdir -p ~/.cache/zsh
[[ ! -d ~/.local/share/zsh ]] && mkdir -p ~/.local/share/zsh

# SOURCES: 
# https://stackoverflow.com/questions/44250002/how-to-solve-sign-and-send-pubkey-signing-failed-agent-refused-operation
# https://wiki.archlinux.org/title/GnuPG#SSH_agent
gpgconf --launch gpg-agent > /dev/null 2>&1
gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1

# Function to source files if they exist
function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

# Who needs oh-my-zsh ?
function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

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
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export ZVM_VI_SURROUND_BINDKEY=s-prefix
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

colored_man=~/.config/zsh/plugins/colored-man-pages.zsh
fzf_bindings=~/.config/zsh/plugins/fzf/key-bindings.zsh
fzf_completion=~/.config/zsh/plugins/fzf/completion.zsh
zsh_menu=~/.config/zsh/plugins/menu.zsh
[ -f $fzf_bindings ] && source $fzf_bindings
[ -f $fzf_completion ] && source $fzf_completion
[ -f $zsh_menu ] && source $zsh_menu
[ -f $colored_man ] && source $colored_man

type "zoxide" >/dev/null && eval "$(zoxide init zsh)"

# add title to terminal to display state,currently executing command, current directory...
autoload -Uz add-zsh-hook
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi
