#!/bin/sh

if [ "$(systemctl is-active bluetooth.service)" = "active" ]; then
	echo "  "
else
	echo "%{F#00ff00}  "
fi
