#!/bin/bash

# audio
A="$(pactl list sources | grep 'analog.*monitor' | awk '{print $2}')"
# screen size
S="$(xdpyinfo | grep dimensions | awk '{print $2}')"
# file name
N="$(date +"%m-%d-%Y_%I:%M%p").mp4"

# Desktop audio + screen recording
ffmpeg \
-s "$S" -r 25 -f x11grab  -i :0.0+0,0 \
-ac 2 ~/"$N"

# ffmpeg can output high quality GIF. Before you start it is always recommended to use a recent version: download or compile.

# ffmpeg -ss 30 -t 3 -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output.gif

#     This example will skip the first 30 seconds (-ss 30) of the input and create a 3 second output (-t 3).
#     fps filter sets the frame rate. A rate of 10 frames per second is used in the example.
#     scale filter will resize the output to 320 pixels wide and automatically determine the height while preserving the aspect ratio. The lanczos scaling algorithm is used in this example.
#     palettegen and paletteuse filters will generate and use a custom palette generated from your input. These filters have many options, so refer to the links for a list of all available options and values. Also see the Advanced options section below.
#     split filter will allow everything to be done in one command and avoids having to create a temporary PNG file of the palette.
#     Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times.
