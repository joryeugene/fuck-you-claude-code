#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Battery status indicator
PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

# Handle error case
if [ -z "$PERCENTAGE" ]; then
  PERCENTAGE=0
fi

# Choose icon based on battery level
if [[ $PERCENTAGE -gt 80 ]]; then
  ICON=󰁹
  COLOR=$GREEN
elif [[ $PERCENTAGE -gt 60 ]]; then
  ICON=󰂀
  COLOR=$GREEN
elif [[ $PERCENTAGE -gt 40 ]]; then
  ICON=󰁾
  COLOR=$YELLOW
elif [[ $PERCENTAGE -gt 20 ]]; then
  ICON=󰁼
  COLOR=$YELLOW
else
  ICON=󰁺
  COLOR=$RED
fi

# Add charging indicator
if [ -n "$CHARGING" ]; then
  ICON=󰂄
  COLOR=$BLUE
fi

sketchybar --set $NAME icon="$ICON" \
                       icon.color=$COLOR \
                       label="${PERCENTAGE}%"
