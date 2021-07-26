########################################
## general settings
########################################

umask 002

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
# nvim as manpager
export MANPAGER="nvim -c 'set ft=man' -"

# append to the history file, don't overwrite it
shopt -s histappend

# ignore simple, repetitive commands
export HISTIGNORE="&:ls:ll:la:cd:exit:clear"

# enable bash_completion if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

########################################
## environmental variables
########################################

# set VIM as my default text editor
export EDITOR='nvim'

# set bash as shell
export SHELL=/bin/bash

# ensures programs know to use 256-colours
if [[ $TERM == "xterm" ]]; then
    export TERM="xterm-256color"
elif [[ $TERM == "screen" ]]; then
    export TERM="screen-256color"
fi

# Provide a kickass prompt
PS1='\[\033[0;36m\](\[\033[01;31m\]ROOT@\[\033[01;32m\]\h\[\033[0;36m\]) \[\033[01;32m\][\[\033[01;31m\]\w\[\033[01;32m\]] #\[\033[00m\] '
#\[\033[0;36m\]$(date "+%H:%M")\n

# force colour prompt
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# fzf
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash

# fkill - kill process
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

# cdf - cd into the directory of the selected file
cdf() {
    local file
    local dir
    file=$(find "${1:-.}" | fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# enable sudo completion
complete -cf sudo

########################################
## aliases
########################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls -Fh --color=always"
    alias ll="ls -Fhl --color=always"
    alias lla="ls -FhlA --color=always"
    alias grep="grep --color=auto"
    alias diff="diff --color=auto"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias vim="nvim"
alias v="nvim"
alias rm="rm -vI"
alias cp="cp -iv"
alias ..="cd .."
alias mv="mv -iv"
