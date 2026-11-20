#!/bin/sh

cd "${1:-$PWD}" || exit 1

FD='fd --strip-cwd-prefix --hidden --exclude=.git --exclude=.jj --type=file'

out=$($FD | fzf-tmux -p -- --color=base16 -m --expect=ctrl-y --prompt='ig> ' \
    --header='enter: insert | ctrl-y: copy | ctrl-g: toggle .gitignore' \
    --bind "ctrl-g:transform:[ \"\$FZF_PROMPT\" = 'ig> ' ] &&
        echo \"change-prompt(  > )+reload($FD --no-ignore)\" ||
        echo \"change-prompt(ig> )+reload($FD)\"")

key=$(printf '%s\n' "$out" | head -n 1)
sel=$(printf '%s\n' "$out" | sed '1d' | tr '\n' ' ')
sel=${sel% }

[ -z "$sel" ] && exit 0

if [ "$key" = "ctrl-y" ]; then
    printf '%s' "$sel" | wl-copy
else
    tmux send-keys -l -- "$sel"
fi
