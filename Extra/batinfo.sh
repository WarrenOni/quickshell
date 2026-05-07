#!/bin/sh
BAT=$(upower -e | grep BAT)
CAP=$(upower -i $BAT | grep -E capacity: | awk '/capacity/ {print $2}')
TIME=$(upower -i $BAT | grep -E "time to" | awk '{print $4,$5}')

jq -n --arg time "$TIME" --arg cap "$CAP" '{"Cap":$cap,"Time":$time}'