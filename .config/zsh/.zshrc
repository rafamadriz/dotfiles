HISTFILE=~/.config/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# export here because for some reason .zshenv doesn't export the path
export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"

# vi mode
bindkey -v
export KEYTIMEOUT=1

autoload -U colors && colors	# Load colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
    vcs_info
}
setopt PROMPT_SUBST
# prompt classic
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

zstyle ':vcs_info:*' actionformats \
    $'%F{4}\UE0A0%F{3} on %F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    $'%F{4}\UE0A0%F{3} on %F{5}[%F{4}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd () { vcs_info }
# prompt 2.0
PS1='%B%{$fg[green]%}~> %B%{$fg[blue]%}[%{$fg[yellow]%}%n %{$fg[magenta]%}%~%{$fg[blue]%}]%{$reset_color%} ${vcs_info_msg_0_}'

if [[ ! -d ~/.cache/zsh ]]; then
    mkdir -p ~/.cache/zsh
fi
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

# aliases
source ~/.config/zsh/alias.sh
source ~/.config/zsh/swallow.sh

# completion menu
source ~/.config/zsh/menu.zsh

# Plugins
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/colored-man-pages/colored-man-pages.plugin.zsh
source ~/.config/zsh/plugins/fzf/key-bindings.zsh
source ~/.config/zsh/plugins/fzf/completion.zsh
