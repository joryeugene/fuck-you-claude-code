#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Date and time display
sketchybar --set $NAME label="$(date '+%a %d %b %H:%M')" \
                       label.color=$FOREGROUND
