#!/bin/bash

function print_usage {
  echo -e "USAGE:\n\t./main.sh /opt/test 4 az 5 az.az 3kb"
}

function log_file_create {
  if [ ! -f "./$LOG_FILE_NAME" ]
  then
    touch "$LOG_FILE_NAME"

    if [ ! -f "./$LOG_FILE_NAME" ]
    then
      echo -e "ERROR:\n\tFile $LOG_FILE_NAME can not be create"
      exit 1
    else
      echo -e "INFO:\n\t$LOG_FILE_NAME logfile created"
    fi
    
  else
    echo -e "INFO:\n\t$LOG_FILE_NAME logfile already exists"
  fi
}
function print_working_time {
  local durationtime="$(( ($2 - $1) / 1000000))"

  echo -e "START:\t[$(date -d"@${1::-9}" '+%d/%b/%Y:%T %z')]"
  echo -e "FREE:\t$3 Mb"
  echo -e "END:\t[$(date -d"@${2::-9}" '+%d/%b/%Y:%T %z')]"
  echo -e "FREE:\t$4 Mb"
  echo -e "DUR:\t${durationtime} ms"
}

function space_available {
  space_MB="$(df -BMB / | awk '{print $4}' | sed -n 2p)"
  space_MB="${space_MB:0:${#space_MB} - 2}"

  echo "$space_MB"
}

function logger {
  echo -e "${1}\t${2}\t${3}" >> "$LOG_FILE_NAME"
}

function gen_folder_name {
  local new_name=""
  local min=4
  local sym=""
  local date=""
  date="$(date '+%d%m%y')"

  for (( i=0; i < ${#FOLDER_NAME_3}; i++ ))
  do
    sym=${FOLDER_NAME_3:$i:1}
    for (( j=0; j < $(( RANDOM % MAX_SYM_NUM + 1 )); j++ ))
    do
      new_name="$new_name$sym"
    done
  done

  while [ ${#new_name} -lt $min ]
  do
    new_name="$new_name$sym"
  done

  echo "${new_name}_${date}"
}

function gen_file_name {
  local new_name=""
  local min=4
  local sym=""
  local date=""
  date="$(date '+%d%m%y')"

  for (( i=0; i < ${#FILES_NAME_5}; i++ ))
  do
    sym=${FILES_NAME_5:$i:1}
    if [ "$sym" != "." ]
    then
      for (( j=0; j < $(( RANDOM % MAX_SYM_NUM_FILES + 1 )); j++ ))
      do
        new_name="$new_name$sym"
      done
    else
      while [ ${#new_name} -lt $min ]
      do
        new_name="${new_name}${FILES_NAME_5:($i-1):1}"
      done

      new_name="${new_name}_${date}."
    fi
  done

  echo "${new_name}"
}

function create_folder {
  local name=""
  local folder_path=""
  name="$(gen_folder_name)"

  if [[ "${PATH_1:0-1}" == "/" ]]
  then
    folder_path="${PATH_1}${name}"
  else
    folder_path="${PATH_1}/${name}"
  fi

  while [ -d "$folder_path" ]
  do
    name="$(gen_folder_name)"

    if [[ "${PATH_1:0-1}" == "/" ]]
    then
      folder_path="${PATH_1}${name}"
    else
      folder_path="${PATH_1}/${name}"
    fi
  done

  mkdir "$folder_path"
  logger "$folder_path" "[$(date '+%d/%b/%Y:%T %z')]" "-"

  echo "$folder_path"
}

function create_files {
  local name=""
  local file_path=""

  for (( i=0; i < "$FILES_NUM_4"; i++ ))
  do
    name="$(gen_file_name)"
    file_path="${1}/${name}"

    while [ -f "$file_path" ]
    do
      name="$(gen_file_name)"
      file_path="${1}/${name}"
    done
  
    fallocate -x -l "${FILES_SIZE_6:0:${#FILES_SIZE_6} - 2}KB" "$file_path"
    logger "$file_path" "[$(date '+%d/%b/%Y:%T %z')]" "$(wc -c "$file_path" | awk '{print $1}')"

  done
}

function create_all {
  (( "MAX_SYM_NUM = 248 / ${#FOLDER_NAME_3}" ))
  (( "MAX_SYM_NUM_FILES = 248 / (${#FILES_NAME_5} - 1)" ))
  local folder_path=""

  for (( ii=0; ii<FOLDERS_NUM_2; ii++ ))
  do
    if [ "$(space_available)" -gt 1000 ]
    then
      folder_path="$(create_folder)"
      create_files "$folder_path"
      folder_path=""
    else
      echo -e "ERROR:\n\tNot enought space"
      exit 1
    fi
  done
}
