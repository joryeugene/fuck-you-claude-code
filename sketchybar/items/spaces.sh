#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Add space change event
sketchybar --add event space_change

# Create space items for spaces 1-6
for sid in {1..6}; do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid space_change \
        --set space.$sid \
        background.color=$GRAY \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=on \
        label.font="$LABEL_FONT" \
        label.padding_left=8 \
        label.padding_right=8 \
        label="$sid" \
        click_script="yabai -m space --focus $sid" \
        script="$HOME/.config/sketchybar/plugins/spaces.sh $sid"
done
