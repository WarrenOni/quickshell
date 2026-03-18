#!/bin/bash 
SLCTD_WALL=$1
if [ -n "$SLCTD_WALL" ]; then 
  timeout 3s script -q -c "matugen image '$SLCTD_WALL'" /tmp/matugen.txt 
  grep -o "#[0-9a-f]*" /tmp/matugen.txt | awk '!seen[$0]++' > /tmp/matugen_choice.txt
  cat /tmp/matugen_choice.txt 
fi

CHOICE=$2

if [ -n "$CHOICE" ]; then 
  matugen image "$SLCTD_WALL" --source-color-index $(grep -n "$CHOICE" /tmp/matugen_choice.txt | cut -d: -f1)
  echo "ran"
fi