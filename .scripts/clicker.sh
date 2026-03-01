#!/bin/bash
#Usage: ./clicker.sh {time in ms}
MS=${1:-1000} # Default to 1000ms if no argument is provided
SLEEP_TIME=$(printf "%.3f" "$(echo "$MS / 1000" | bc -l)") # Convert milliseconds to seconds for the sleep command
echo "Clicking every ${MS}ms. Press Ctrl+C to stop."
while true; do
    xdotool click 1
    sleep "$SLEEP_TIME"
done
