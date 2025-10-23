#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item wifi right \
           --set wifi update_freq=10 \
                      icon=󰖩 \
                      icon.color=$FOREGROUND \
                      icon.font="$ICON_FONT" \
                      icon.padding_left=8 \
                      icon.padding_right=4 \
                      label.font="$LABEL_FONT" \
                      label.padding_right=8 \
                      background.color=$GRAY \
                      background.corner_radius=5 \
                      background.height=20 \
                      script="$HOME/.config/sketchybar/plugins/wifi.sh" \
                      click_script="open x-apple.systempreferences:com.apple.preference.network"
