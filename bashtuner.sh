#!/bin/bash

# Written by Storm Dragon https://social.stormdragon.tk/storm
# Released under the terms of the WTFPL License http://wtfpl.net

declare -A tuning=(
  # Dropped 1 step.
  [6d]="D2 G2 C3 F3 A3 D4"
  # Standard tuning
  [6e]="E2 A2 D3 G3 B3 E4"
  # 12 string dropped 1 step.
  [12d]="D2 D3 G2 G3 C3 C4 F3 F4 A3 D4"
  # 12 string standard tuning
  [6e]="E2 E3 A2 A3 D3 D4 G3 G4 B3 E4"
  # Mandolin
  [mandolin]="G3 D4 A4 E5"
)

show_help() {
  echo "Usage: $0 tune_id"
  echo "Where tune_id is one of"
  echo "${!tuning[@]}"
exit 0
}

[ $# -ne 1  ] && show_help
[ -z "${tuning[$1]}" ] && show_help
[ "$1" == "-h" ] && show_help
[ "$1" == "--help" ] && show_help

# Continuously play the notes until a key is press.
# Note key can not be enter or space.
# This will adjust how long each note plays.
timeout=2
for i in ${tuning[$1]} ; do
  unset continue
  ifs="$IFS"
  IFS=""
  while [[ -z "$continue" ]]; do
    ps $notePID &> /dev/null && kill $notePID &> /dev/null
    play -qnV0 synth $timeout pl $i &
    notePID="$!"
    read -sN1 -t $timeout continue
  done
  IFS="$ifs"
done
