#!/usr/bin/bash
meteo=$(curl wttr.in/Toronto?format=1 | xargs echo)
first="${meteo%% *}"
if [ "$meteo" == "" ] || [ "$first" == "Unknown" ]; then
  echo "  Off"

else
  echo $meteo
fi
