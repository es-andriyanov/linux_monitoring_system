#!/bin/bash

function print_usage {
  echo -e "USAGE:\n\t./main.sh 1"
  echo -e "\t 1 - All entries sorted by STATUS CODE"
  echo -e "\t 2 - All unique IPs"
  echo -e "\t 3 - All entries by 4xx and 5xx status codes"
  echo -e "\t 4 - All unique IPs with 4xx and 5xx status codes"
}

function print_working_time {
  local durationtime="$(( ($2 - $1) / 1000000))"

  echo -e "START:\t[$(date -d"@${1::-9}" '+%d/%b/%Y:%T %z')]"
  echo -e "END:\t[$(date -d"@${2::-9}" '+%d/%b/%Y:%T %z')]"
  echo -e "DUR:\t${durationtime} ms"
}

function logger {
  echo -e "${1}\t${2}\t${3}" >> "$LOG_FILE_NAME"
}

function calc_1 {
  local res=""
  local path=""

  path="$(ls $LOG_FILE_PATH | sed "s!^!$LOG_FILE_PATH/!")"
  res=$(awk '{ print $0 | "sort -k8" }' $path)

  echo "$res"
  echo "===TOTAL ENTRIES: $(echo "$res" | wc -l)==="
}

function calc_2 {
  local res=""
  local path=""
  
  path="$(ls $LOG_FILE_PATH | sed "s!^!$LOG_FILE_PATH/!")"
  res=$(awk '{ print $1 | "sort -u" }' $path)

  echo "$res"
  echo "===TOTAL ENTRIES: $(echo "$res" | wc -l)==="
}

function calc_3 {
  local res=""
  local path=""

  path="$(ls $LOG_FILE_PATH | sed "s!^!$LOG_FILE_PATH/!")"
  res=$(awk '{ if ($9 ~ "^[4|5][0-9][0-9]$") print $0 }' $path)

  echo "$res"
  echo "===TOTAL ENTRIES: $(echo "$res" | wc -l)==="
}

function calc_4 {
  local res=""
  local path=""

  path="$(ls $LOG_FILE_PATH | sed "s!^!$LOG_FILE_PATH/!")"
  res=$(awk '{ if ($9 ~ "^[4|5][0-9][0-9]$") print $1 | "sort -u" }' $path)

  echo "$res"
  echo "===TOTAL ENTRIES: $(echo "$res" | wc -l)==="
}

function calc_all {
  if [[ "$WAY_1" == 1 ]]
  then
    calc_1
  elif [[ "$WAY_1" == 2 ]]
  then
    calc_2
  elif [[ "$WAY_1" == 3 ]]
  then
    calc_3
  elif [[ "$WAY_1" == 4 ]]
  then
    calc_4
  else
    echo -e "ERROR:\n\tUnknown way"
    print_usage
    exit 1
  fi
}
