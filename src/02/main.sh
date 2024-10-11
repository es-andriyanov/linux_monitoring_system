#!/bin/bash

if [ -f "./func.sh" ]
then
  source ./func.sh
fi

$answer
$filename

print_params

read -r -p "Would you like to save this? (Y/N)" answer

if [[ "$answer" =~ ^[Yy]$ ]]
then
  filename="$(get_filename)"
  print_params > "$filename"
  if [ -f "$filename" ]
  then
    echo "Saved"
  else
    echo "ERROR: Problems with saving"
  fi
else
  echo "Not saved ($answer pressed)"
fi
