#!/bin/bash

if [ -f "./func.sh" ]
then
  source ./func.sh
fi

if [ $# -ne 0 ] 
  then 
    echo "ERROR: Don't use params"
    exit 1
fi

$background1
$text1
$background2
$text2
$config
$config_flag
$tmp

config=("6" "1" "6" "1")
config_flag=("0" "0" "0" "0")

if [ -f "./config.conf" ]
then
  tmp="$(grep -E "^column1_background=[1-6]$" ./config.conf)"
  if [[ -n "$tmp" ]]
  then
    config[0]=$(echo "$tmp" | cut -d= -f 2)
    config_flag[0]="1"
  fi

  tmp="$(grep -E "^column1_font_color=[1-6]$" ./config.conf)"
  if [[ -n "$tmp" ]]
  then
    config[1]=$(echo "$tmp" | cut -d= -f 2)
    config_flag[1]="1"
  fi

  tmp="$(grep -E "^column2_background=[1-6]$" ./config.conf)"
  if [[ -n "$tmp" ]]
  then
    config[2]=$(echo "$tmp" | cut -d= -f 2)
    config_flag[2]="1"
  fi

  tmp="$(grep -E "^column2_font_color=[1-6]$" ./config.conf)"
  if [[ -n "$tmp" ]]
  then
    config[3]=$(echo "$tmp" | cut -d= -f 2)
    config_flag[3]="1"
  fi

  if [[ "${config[0]}" = "${config[1]}" ]] || [[ "${config[2]}" = "${config[3]}" ]] 
  then
    echo -e "ERROR: BACKGROUND color can't be uqual TEXT color of the same column. Please, edit config"
    exit 1
  fi
fi

background1=$(get_background "${config[0]}")
text1=$(get_text "${config[1]}")
background2=$(get_background "${config[2]}")
text2=$(get_text "${config[3]}")

print_params "$background1" "$text1" "$background2" "$text2"
print_config "${config[0]}" "${config[1]}" "${config[2]}" "${config[3]}" "${config_flag[0]}" "${config_flag[1]}" "${config_flag[2]}" "${config_flag[3]}"