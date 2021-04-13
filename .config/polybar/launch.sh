#!/usr/bin/env bash

DIR="$HOME/.config/polybar/"

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar -q example -c "$DIR"/config.ini 2>&1 | tee -a /tmp/polybar2.log &
