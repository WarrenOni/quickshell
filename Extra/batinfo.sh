#!/bin/sh
BAT=$(upower -e | grep BAT)
CAP=$(upower -i $BAT | grep -E capacity: | awk '/capacity/ {print $2}')
TIME=$(upower -i $BAT | grep -E "time to" | awk '{print $4,$5}')
Profile=$(powerprofilesctl get)
jq -n --arg time "$TIME" --arg cap "$CAP" --arg Profile "$Profile" '{"Cap":$cap,"Time":$time,"Current_Profile":$Profile}'