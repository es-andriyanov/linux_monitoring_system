#!/bin/bash

# Script time start
starttime="$(date '+%s%N')"
endtime=""

# Looking for config.sh:
if [ -f "./config.sh" ]
then
  source "./config.sh"
else
  echo -e "ERROR:\n\tCan't start without ./config.sh file"
  exit 1
fi

# Looking for all $FILES (from config.sh):
for file in "${FILES[@]}"
do
  if [ -f "./$file" ]
  then
    source "./$file"
  else
    echo -e "ERROR:\n\tFile $file not found"
    exit 1
  fi
done

# Script begin:
available_start="$(space_available)"

validate_params
log_file_create
create_all

endtime="$(date '+%s%N')"
available_end="$(space_available)"
print_working_time "$starttime" "$endtime" "$available_start" "$available_end"
