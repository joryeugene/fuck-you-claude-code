#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get WiFi info
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/ {getline; print $NF}')
WIFI_STATUS=$(ifconfig "$WIFI_DEVICE" 2>/dev/null | grep 'status:' | awk '{print $2}')
WIFI_SSID=$(networksetup -getairportnetwork "$WIFI_DEVICE" 2>/dev/null | sed 's/Current Wi-Fi Network: //')

# Determine icon and label
if [ "$WIFI_STATUS" = "active" ]; then
    ICON="󰖩"
    COLOR=$GREEN
    if [ -n "$WIFI_SSID" ] && [ "$WIFI_SSID" != "You are not associated with an AirPort network." ]; then
        LABEL="$WIFI_SSID"
    else
        LABEL="Connected"
    fi
else
    ICON="󰖪"
    COLOR=$RED
    LABEL="Disconnected"
fi

sketchybar --set $NAME icon="$ICON" \
                       icon.color=$COLOR \
                       label="$LABEL"
