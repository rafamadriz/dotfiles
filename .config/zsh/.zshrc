HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# vi mode
bindkey -v
export KEYTIMEOUT=1
export LC_CTYPE="en_US.UTF-8"
export XAUTHORITY="$XDG_CACHE_HOME"/Xauthority

# prompt
source ~/.config/zsh/prompt.zsh

if [[ ! -d ~/.cache/zsh ]]; then
    mkdir -p ~/.cache/zsh
fi

if [[ ! -d ~/.local/share/zsh ]]; then
    mkdir -p ~/.local/share/zsh
fi

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

# aliases
source ~/.config/zsh/aliasrc
source ~/.config/zsh/devour.sh

# completion menu
source ~/.config/zsh/menu.zsh

# Plugins
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.config/zsh/plugins/colored-man-pages/colored-man-pages.plugin.zsh
source ~/.config/zsh/plugins/fzf/key-bindings.zsh
source ~/.config/zsh/plugins/fzf/completion.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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
