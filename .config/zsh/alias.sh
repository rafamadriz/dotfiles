#!/bin/sh

# add color to commands
alias \
    ls="exa --color=always" \
    grep="grep --color=auto" \
    diff="diff --color=auto" \
    dir='dir --color=auto' \
    vdir='vdir --color=auto' \
    grep='grep --color=auto' \
    fgrep='fgrep --color=auto' \
    egrep='egrep --color=auto' \
\

# shortcuts
alias \
    startx='startx $HOME/.config/X11/xinitrc'\
    untar='tar -xvf' \
    vim='nvim' \
    v='nvim' \
    rm='rm -vI' \
    ..='cd ..' \
    cp='cp -iv' \
    mv='mv -iv' \
    media='cd /media/rafa/Media' \
    play='~/.config/scripts/mpv-fullscreen.sh' \
    getmusic='~/.config/scripts/getmusic.sh' \
    config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
\

# search for all scripts and dotfiles, then open them with editor of choice
sc() {
    du -a ~/.config/* ~/.local/bin/* | awk '{print $2}' | fzf | xargs -r $EDITOR ;
}

# fd - cd into any hidden directory of the current folder
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(find ${1:-.} | fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
