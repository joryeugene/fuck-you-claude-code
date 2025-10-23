#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get memory usage percentage using memory_pressure
MEMORY_USAGE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{printf("%d", 100-$5)}')

# Handle error case
if [ -z "$MEMORY_USAGE" ]; then
    MEMORY_USAGE=0
fi

# Color-code based on memory usage
if [ "$MEMORY_USAGE" -gt 80 ]; then
    COLOR=$RED
elif [ "$MEMORY_USAGE" -gt 60 ]; then
    COLOR=$YELLOW
else
    COLOR=$GREEN
fi

sketchybar --set $NAME label="$(printf "MEM %02d%%" $MEMORY_USAGE)" \
                       label.color=$COLOR
