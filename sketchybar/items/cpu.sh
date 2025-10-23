#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item cpu right \
           --set cpu update_freq=3 \
                     icon= \
                     icon.color=$BLUE \
                     icon.font="$ICON_FONT" \
                     icon.padding_left=8 \
                     icon.padding_right=4 \
                     label.font="$LABEL_FONT" \
                     label.padding_right=8 \
                     background.color=$GRAY \
                     background.corner_radius=5 \
                     background.height=20 \
                     script="$HOME/.config/sketchybar/plugins/cpu.sh" \
                     click_script="open -a 'Activity Monitor'"
