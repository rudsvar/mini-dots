#!/usr/bin/env sh

printf "🎶 "

status=$(playerctl -p spotify status)
if [[ $status = "" ]]; then
    exit 0
fi

title=$(playerctl -p spotify metadata xesam:title)
artist=$(playerctl -p spotify metadata xesam:artist)

echo "$status \"$title\" by $artist"
