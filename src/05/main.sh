#!/bin/bash

time_start="$(date +%s.%N)"

if [ -f "./func.sh" ]
then
  source ./func.sh
fi

if [ $# -ne 1 ] 
then 
  echo -e "ERROR:"
  echo -e "\tScript should take (1) text param, but not ($#)"
  print_usage
  exit 1
fi

if [ "$(echo "$1" | awk '{ print substr($0, length($0), length($0)) }')" != "/" ]
then 
  echo -e "ERROR:"
  echo -e "\tPATH should ends with /"
  print_usage
  exit 1
fi

if [ ! -d "$1" ]
then
  echo -e "ERROR:"
  echo -e "\tDirectory by the PATH doesn't exist"
  print_usage
  exit 1
fi

print_result "$1" "$time_start"
