#!/bin/bash
Cache="$HOME/.cache/launcher_cache"
#check for cache if exist use it instead
if [[ -f "$Cache" ]];then
    cat "$Cache"
    exit 0
fi

#shopt -s nullglob #nulls out loc from output if either of the search loc fails

for file in /usr/share/applications/*.desktop;do
    name=$(grep -m1 "^Name=" "$file" | cut -d= -f2)
    exec=$(grep -m1 "^Exec=" "$file" | cut -d= -f2 | sed 's/%.*//')
    icon=$(grep -m1 "^Icon=" "$file" | cut -d= -f2)

    if [[ -n "$name" && -n "$exec" && "$exec" != *"-jar"* ]];then
        jq -n --arg name "$name" --arg exec "$exec" --arg icon "$icon" '{name: $name, exec: $exec, icon: $icon}'
    fi
done | jq -s '.' > "$Cache"
cat "$Cache"