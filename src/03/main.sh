#!/bin/bash

if [ -f "./func.sh" ]
then
  source ./func.sh
fi

if [ "$#" -ne 4 ] 
then
  echo -e "ERROR:"
  echo -e "\tScript should take (4) number params, but not ($#)"
  print_usage
  exit 1
fi

for a in "$@"
do
  if ! [[ $a =~ ^[1-6]$ ]]
  then
    echo -e "ERROR:"
    echo -e "\tParam ($a) is not a number from 1 to 6"
    print_usage
    exit 1
  fi
done

if [[ "$1" = "$2" ]] || [[ "$3" = "$4" ]] 
then
  echo -e "ERROR:"
  echo -e "\tBACKGROUND color can't be uqual TEXT color of the same column. Rerun with other params"
  print_usage
  exit 1
fi

$background1
$text1
$background2
$text2

background1=$(get_background "$1")
text1=$(get_text "$2")
background2=$(get_background "$3")
text2=$(get_text "$4")

print_params "$background1" "$text1" "$background2" "$text2"
