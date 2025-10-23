#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item memory right \
           --set memory update_freq=5 \
                        icon= \
                        icon.color=$GREEN \
                        icon.font="$ICON_FONT" \
                        icon.padding_left=8 \
                        icon.padding_right=4 \
                        label.font="$LABEL_FONT" \
                        label.padding_right=8 \
                        background.color=$GRAY \
                        background.corner_radius=5 \
                        background.height=20 \
                        script="$HOME/.config/sketchybar/plugins/memory.sh" \
                        click_script="open -a 'Activity Monitor'"
