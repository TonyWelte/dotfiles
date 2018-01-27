#!/bin/sh

if grep -q ON /proc/acpi/bbswitch; then
      echo "%{F#76b900}  "
else
    echo "%{F#0071c5}  "
fi
