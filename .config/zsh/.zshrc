HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# SOURCES: 
# https://stackoverflow.com/questions/44250002/how-to-solve-sign-and-send-pubkey-signing-failed-agent-refused-operation
# https://wiki.archlinux.org/title/GnuPG#SSH_agent
gpgconf --launch gpg-agent > /dev/null 2>&1
gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1

# vi mode
bindkey -v
export KEYTIMEOUT=1

# prompt
source ~/.config/zsh/prompt.zsh

# these directories are necessary for zsh.
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
bindkey -s '^n' 'notes\n'
bindkey -s '^p' 'dotf\n'
bindkey -s '^e' 'live_search_notes\n'

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
