#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get CPU usage percentage from top command
# Takes average of user and sys CPU from second sample
CPU_USAGE=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{print int($3 + $5)}')

# Handle error case
if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE=0
fi

# Color-code based on CPU usage
if [ "$CPU_USAGE" -gt 80 ]; then
    COLOR=$RED
elif [ "$CPU_USAGE" -gt 50 ]; then
    COLOR=$YELLOW
else
    COLOR=$GREEN
fi

sketchybar --set $NAME label="$(printf "CPU %02d%%" $CPU_USAGE)" \
                       label.color=$COLOR
