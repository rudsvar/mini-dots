#!/bin/sh
for i in $(seq 1 12); do
    t=$(curl -Ss --max-time 5 'https://wttr.in/?format=%t' 2>/dev/null)
    [ -n "$t" ] && echo "⛅ $t" && exit 0
    sleep 5
done
echo "⛅ ?"
