#!/bin/bash

# Battery status indicator

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

# Choose icon based on battery level
if [[ $PERCENTAGE -gt 80 ]]; then
  ICON=󰁹
elif [[ $PERCENTAGE -gt 60 ]]; then
  ICON=󰂀
elif [[ $PERCENTAGE -gt 40 ]]; then
  ICON=󰁾
elif [[ $PERCENTAGE -gt 20 ]]; then
  ICON=󰁼
else
  ICON=󰁺
fi

# Add charging indicator
if [ "$CHARGING" != "" ]; then
  ICON=󰂄
fi

sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
