#!/bin/bash

# Written by Storm Dragon https://social.stormdragon.tk/storm
# Released under the terms of the WTFPL License http://wtfpl.net

declare -A tuning=(
  # Dropped 1 step.
  [6d]="D2 G2 C3 F3 A3 D4"
  # Standard tuning
  [6e]="E2 A2 D3 G3 B3 E4"
#dadgad 6-string
[dadgad]="D2 A2 D3 G3 A3 D4"
  #Open D
  [open-d]="D2 A2 D3 F#3 A3 D4"
#drop D 6 String
[drop-d]="D2 A2 D3 G3 B3 E4"
  #Drop DG
  [Drop-dg]="D2 G2 D3 G3 B3 E4"
  #Open G
  [[open-g]]="D2 G2 D3 G3 B3 D4"
  # 12 string dropped 1 step.
  [12d]="D3 D2 G3 G2 C4 C3 F4 F3 A3 D4"
  # 12 string standard tuning
  [12e]="E3 E2 A3 A2 D4 D3 G4 G3 B3 E4"
  # Mandolin
  [mandolin]="G3 D4 A4 E5"
#Ukulele
  [ukulele]="G4 C4 E4 A4"
  #Nick Drake Tuning
  [nick-drake-tuning]="C2 G2 C3 F3 C4 E4"
  #banjo
  [banjo]="G4 D3 G3 B3 D4"
)
export DIALOGOPTS='--insecure --no-lines --visit-items'

flush_keys() {
    local keys
    read -st0.001 keys
}

show_help() {
  echo "Usage: $0 tune_id"
  echo "Where tune_id is one of"
  echo "${!tuning[@]}"
exit 0
}

if [[ $# -eq 0 ]]; then
    set -- $(dialog --backtitle "Welcome to Bash Tuner" \
        --no-tags \
        --menu "Select tuning" 0 0 0 \
        $(for i in ${!tuning[@]} ; do echo "$i";echo "$i";done) --stdout)
    [[ -z $1 ]] && exit 0
fi

[ $# -gt 1  ] && show_help
[ -z "${tuning[$1]}" ] && show_help
[ "$1" == "-h" ] && show_help
[ "$1" == "--help" ] && show_help

# Continuously play the notes until a key is press.
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
    flush_keys
  done
  IFS="$ifs"
done
# Kill the final process when the program exits.
    ps $notePID &> /dev/null && kill $notePID &> /dev/null
exit 0
