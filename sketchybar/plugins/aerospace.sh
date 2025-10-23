#!/bin/bash

# Aerospace workspace indicator
# This script highlights the currently focused workspace

# Colors
BLUE=0xff89b4fa
GRAY=0xff6c7086

# Get the workspace ID from the environment variable
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.color=$BLUE
else
    sketchybar --set $NAME background.color=$GRAY
fi
