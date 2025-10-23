#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Yabai space indicator with window count
# This script highlights the currently focused space and shows window count

# Get the space ID from the argument
SPACE_ID=$1

# Get current focused space
FOCUSED_SPACE=$(yabai -m query --spaces --space | jq -r .index)

# Count windows in this space
WINDOW_COUNT=$(yabai -m query --windows --space "$SPACE_ID" | jq 'length')

# Build the label (space number + window count if > 0)
if [ "$WINDOW_COUNT" -gt 0 ]; then
    LABEL="$SPACE_ID ($WINDOW_COUNT)"
else
    LABEL="$SPACE_ID"
fi

# Set colors and label based on focus
if [ "$SPACE_ID" = "$FOCUSED_SPACE" ]; then
    sketchybar --set $NAME \
        background.color=$BLUE \
        label="$LABEL" \
        label.color=$BACKGROUND
else
    if [ "$WINDOW_COUNT" -gt 0 ]; then
        # Non-focused with windows
        sketchybar --set $NAME \
            background.color=$GRAY \
            label="$LABEL" \
            label.color=$FOREGROUND
    else
        # Empty space
        sketchybar --set $NAME \
            background.color=$DIM \
            label="$LABEL" \
            label.color=$GRAY
    fi
fi
