#!/usr/bin/env sh

status=$(playerctl -p spotify status 2>/dev/null)
if [ -z "$status" ]; then
    exit 1
fi

title=$(playerctl -p spotify metadata xesam:title)
artist=$(playerctl -p spotify metadata xesam:artist)

echo "$status \"$title\" by $artist"
