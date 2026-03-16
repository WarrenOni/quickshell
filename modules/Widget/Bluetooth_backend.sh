#!/usr/bin/env bash
if [ "$1" != "scan" ];then
POWER=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$POWER" != "yes" ]; then
    echo '{"power":"off","connected":null,"devices":[]}'
    exit 0
fi

# Get connected device
CONNECTED_MAC=$(bluetoothctl devices Connected | awk '{print $2}')

if [[ -n "$CONNECTED_MAC" ]]; then
    NAME=$(bluetoothctl info "$CONNECTED_MAC" | grep "Name:" | cut -d' ' -f2-)
    TYPE=$(bluetoothctl info "$CONNECTED_MAC" | grep "Icon:" | awk '{print $2}')

    CONNECTED_JSON=$(jq -n \
        --arg name "$NAME" \
        --arg mac "$CONNECTED_MAC" \
        --arg type "$TYPE" \
        '{name:$name, mac:$mac, type:$type}')
else
    CONNECTED_JSON="null"
fi

DEVICES_JSON=$(bluetoothctl devices | \
while read -r _ mac name; do
    jq -n \
        --arg name "$name" \
        --arg mac "$mac" \
        '{name:$name, mac:$mac}'
done | jq -s '.')

jq -n \
   --arg power "on" \
   --argjson connected "$CONNECTED_JSON" \
   --argjson devices "$DEVICES_JSON" \
   '{power:$power, connected:$connected, devices:$devices}'
fi

if [ "$1" == "scan" ];then 
    bluetoothctl scan on > /dev/null 2>&1 & sleep 3
    bluetoothctl scan off > /dev/null 2>&1

    bluetoothctl devices | while read -r _ mac name; do
        echo "$name ($mac)"
    done
fi

