#!/bin/sh

case "$1" in
    --toggle)
        if [ "$(pgrep dropbox)" ]; then
            pkill -f dropbox
    	else
            /home/tonywelte/.dropbox-dist/dropboxd &
        fi
        ;;
    *)
        if [ "$(pgrep dropbox)" ]; then
            echo "%{F#3d9ae8}  "
        else
            echo "%{F#c26517}  "
        fi
        ;;
esac
