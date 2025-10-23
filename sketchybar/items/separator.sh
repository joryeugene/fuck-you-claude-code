#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Separator item - creates a visual divider between groups
SEP_NAME="$1"

sketchybar --add item "$SEP_NAME" right \
           --set "$SEP_NAME" icon="|" \
                             icon.color=$DIM \
                             icon.padding_right=0 \
                             label.drawing=off \
                             background.drawing=off \
                             padding_left=5 \
                             padding_right=5
