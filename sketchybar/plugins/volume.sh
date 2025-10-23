#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Volume indicator
VOLUME=$(osascript -e "output volume of (get volume settings)" 2>/dev/null)
MUTED=$(osascript -e "output muted of (get volume settings)" 2>/dev/null)

# Handle error case
if [ -z "$VOLUME" ]; then
    VOLUME=0
fi

if [[ $MUTED == "true" ]]; then
  ICON=󰖁
  LABEL="Muted"
  COLOR=$RED
else
  if [[ $VOLUME -gt 66 ]]; then
    ICON=󰕾
  elif [[ $VOLUME -gt 33 ]]; then
    ICON=󰖀
  else
    ICON=󰕿
  fi
  LABEL="${VOLUME}%"
  COLOR=$FOREGROUND
fi

sketchybar --set $NAME icon="$ICON" \
                       icon.color=$COLOR \
                       label="$LABEL"
