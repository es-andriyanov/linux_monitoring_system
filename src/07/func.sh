#!/bin/bash

function print_usage {
  echo -e "USAGE:\n\t./main.sh az az.az 3Mb"
}

function print_and_log_working_time {
  local durationtime="$(( ($2 - $1) / 1000000))"

  echo -e "START:\t[$(date -d"@${1::-9}" '+%d/%b/%Y:%T %z')]"
  echo -en "START:[$(date -d"@${1::-9}" '+%d/%b/%Y:%T %z')]" >> "$LOG_FILE_NAME"
  echo -e "FREE:\t$3 Mb"
  echo -e "END:\t[$(date -d"@${2::-9}" '+%d/%b/%Y:%T %z')]"
  echo -en "END:[$(date -d"@${2::-9}" '+%d/%b/%Y:%T %z')]" >> "$LOG_FILE_NAME"
  echo -e "FREE:\t$4 Mb"
  echo -e "DUR:\t${durationtime} ms"
  echo -e "DUR:${durationtime} ms" >> "$LOG_FILE_NAME"
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
  local min=5
  local sym=""
  local date=""
  date="$(date '+%d%m%y')"

  for (( i=0; i < ${#FOLDER_NAME_1}; i++ ))
  do
    sym=${FOLDER_NAME_1:$i:1}
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
  local min=5
  local sym=""
  local date=""
  date="$(date '+%d%m%y')"

  for (( i=0; i < ${#FILES_NAME_2}; i++ ))
  do
    sym=${FILES_NAME_2:$i:1}
    if [ "$sym" != "." ]
    then
      for (( j=0; j < $(( RANDOM % MAX_SYM_NUM_FILES + 1 )); j++ ))
      do
        new_name="$new_name$sym"
      done
    else
      while [ ${#new_name} -lt $min ]
      do
        new_name="${new_name}${FILES_NAME_2:($i-1):1}"
      done

      new_name="${new_name}_${date}."
    fi
  done

  echo "${new_name}"
}

function gen_folder_path {
  # local new_path="/home/adinamar/test1/test2"
  local directory="bin"
  local endPath="/"

  while [[ "$endPath/$directory" =~ $FORBIDDEN ]]
  do
    directory=""
    endPath="/"

    for (( i=1; i <= $(shuf -i 1-$MAX_PATH_RANGE -n1); i++ ))
    do
      directory="$(find "$endPath" -maxdepth 1 -type d ! -path "$endPath" -printf "%f\n" 2>/dev/null | shuf -n 1)"

      if [[ -z $directory ]]
      then 
        break
      fi

      endPath="$endPath/$directory"
    done
  done

  echo "${endPath:1:${#endPath}}"
}

function create_folder {
  local is_done=0
  local folder_path=""
  local name=""

  while [ "$is_done" != "1" ]
  do
    folder_path="$(gen_folder_path)"
    name="$(gen_folder_name)"

    while [ -d "${folder_path}/${name}" ]
    do
      name="$(gen_folder_name)"
    done

    mkdir "${folder_path}/${name}" 2>/dev/null

    if [ -d "${folder_path}/${name}" ]
    then
      is_done=1
    fi
  done

  logger "${folder_path}/${name}" "[$(date '+%d/%b/%Y:%T %z')]" "-"
  echo "${folder_path}/${name}"
}

function create_files {
  local name=""

  for (( i=0; i < $(( RANDOM % MAX_FILES_NUM + 1 )); i++ ))
  do
    name="$(gen_file_name)"

    while [ -f "${1}/${name}" ]
    do
      name="$(gen_file_name)"
    done

    if [ "$(space_available)" -gt $LIMIT_MB ]
    then
      fallocate -x -l "${FILES_SIZE_3:0:${#FILES_SIZE_3} - 2}MB" "${1}/${name}"
      logger "${1}/${name}" "[$(date '+%d/%b/%Y:%T %z')]" "$(wc -c "${1}/${name}" | awk '{print $1}')"
    fi

  done
}

function create_all {
  (( "MAX_SYM_NUM = 248 / ${#FOLDER_NAME_1}" ))
  (( "MAX_SYM_NUM_FILES = 248 / (${#FILES_NAME_2} - 1)" ))
  local folder_path=""

  while [ "$(space_available)" -gt $LIMIT_MB ]
  do
    folder_path="$(create_folder)"
    create_files "$folder_path"
    folder_path=""
  done

  echo -e "INFO:\n\tLess than 1Gb space available now"
}
