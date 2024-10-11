#!/bin/bash

function parse {
  if [ $# -ne 1 ] 
  then 
    echo "ERROR: Script should take (1) text param, but not ($#)"
    exit 1
  else
    local res="$1"
  fi

  if [ -z "$res" ] 
  then 
    echo "ERROR: Param is empty"
    exit 1
  fi

  if echo "$res" | grep -qE "^[0-9]+$|^[0-9]+\.[0-9]+$"
  then
    echo "ERROR: It's a number"
    exit 1
  else
    echo "$res"
  fi  
}
