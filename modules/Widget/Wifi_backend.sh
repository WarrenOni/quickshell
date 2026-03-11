#!/usr/bin/bash

POWER=$(nmcli radio wifi)

if [ "$POWER" == "disabled" ]; then
    echo '{"power":"off","connected":null,"networks":[]}'
    exit 0
fi

get_icon() {
    local signal=$1
    if [[ $signal -ge 80 ]]; then echo "󰤨";
    elif [[ $signal -ge 60 ]]; then echo "󰤥";
    elif [[ $signal -ge 40 ]]; then echo "󰤢";
    elif [[ $signal -ge 20 ]]; then echo "󰤟";
    else echo "󰤯";
    fi
}

CURRENT_RAW=$(nmcli -t -f active,ssid,signal,security device wifi | grep "^yes")

if [[ -n "$CURRENT_RAW" ]]; then
    IFS=':' read -r active ssid signal security <<< "$CURRENT_RAW"
    
    icon=$(get_icon "$signal")
    
    CONNECTED_JSON=$(jq -n \
        --arg ssid "$ssid" \
        --arg icon "$icon" \
        --arg signal "$signal" \
        --arg security "$security" \
        '{ssid: $ssid, icon: $icon, signal: $signal, security: $security}')
else
    CONNECTED_JSON="null"
fi

NETWORKS_JSON=$(nmcli -t -f active,ssid,signal,security device wifi list | \
    awk -F: '$3 > 10 && !seen[$2]++ && $2 != "" && $1 != "yes" {print $2":"$3":"$4}' | \
    head -n 20 | \
    while IFS=':' read -r ssid signal security; do
        icon=$(get_icon "$signal")
        jq -n \
           --arg ssid "$ssid" \
           --arg icon "$icon" \
           --arg signal "$signal" \
           --arg security "$security" \
           '{ssid: $ssid, icon: $icon, signal: $signal, security: $security}'
    done | jq -s '.')

jq -n \
   --arg power "on" \
   --argjson connected "$CONNECTED_JSON" \
   --argjson networks "$NETWORKS_JSON" \
   '{power: $power, connected: $connected, networks: $networks}'