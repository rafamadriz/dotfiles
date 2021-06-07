HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# vi mode
bindkey -v
export KEYTIMEOUT=1

# prompt
source ~/.config/zsh/prompt.zsh

# these directories are necessary for zsh, to
# create history file, etc... Create them if don't exist
[[ ! -d ~/.cache/zsh ]] && mkdir -p ~/.cache/zsh
[[ ! -d ~/.local/share/zsh ]] && mkdir -p ~/.local/share/zsh

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
kitty + complete setup zsh | source /dev/stdin

# Exports
source ~/.zshenv

# aliases
source ~/.config/zsh/aliasrc

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/substring-search.zsh
source ~/.config/zsh/plugins/colored-man-pages.zsh
source ~/.config/zsh/plugins/fzf/key-bindings.zsh
source ~/.config/zsh/plugins/fzf/completion.zsh
source ~/.config/zsh/plugins/menu.zsh

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
