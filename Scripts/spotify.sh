#!/usr/bin/env sh

STATUS=$(playerctl -p spotify status)
if [[ $STATUS = "" ]]; then
    exit 0
fi

TITLE=$(playerctl -p spotify metadata xesam:title)
ARTIST=$(playerctl -p spotify metadata xesam:artist)

echo "$STATUS \"$TITLE\" by $ARTIST"
