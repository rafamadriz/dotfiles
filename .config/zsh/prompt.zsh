# Load colors
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
    vcs_info
}
setopt PROMPT_SUBST

# prompt classic
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# prompt 2.0
PS1='%B%{$fg[green]%}~> %B%{$fg[blue]%}[%{$fg[yellow]%}%n %{$fg[magenta]%}%~%{$fg[blue]%}]%{$reset_color%} ${vcs_info_msg_0_}'

zstyle ':vcs_info:*' actionformats \
    $'%F{4}\UE0A0%F{3} on %F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    $'%F{4}\UE0A0%F{3} on %F{5}[%F{4}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
