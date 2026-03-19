#!/bin/bash
Cache="$HOME/.cache/launcher_cache"
#check for cache if exist use it instead
if [[ -f "$Cache" ]];then
    cat "$Cache"
    exit 0
fi

shopt -s nullglob #nulls out loc from output if either of the search loc fails

for file in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop;do
    name=$(grep -m1 "^Name=" "$file" | cut -d= -f2)
    exec=$(grep -m1 "^Exec=" "$file" | cut -d= -f2 | sed 's/%.*//')

    if [[ -n "$name" && -n "$exec" && "$exec" != *"-jar"* ]];then
        jq -n --arg name "$name" --arg exec "$exec" '{name: $name, exec: $exec}'
    fi
done > "$Cache"
cat "$Cache"