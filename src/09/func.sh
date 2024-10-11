#!/bin/bash

function print_usage {
  echo -e "USAGE:\n\t./main.sh"
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

function gen_ip_2 {
  local ip=""

  ip="$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1)"

  echo "$ip"
}

function gen_ip {
  echo -n "${RANDOM_IP[$(( $(shuf -i 1-${#RANDOM_IP[@]} -n 1) - 1 ))]}."
  echo -n "${RANDOM_IP[$(( $(shuf -i 1-${#RANDOM_IP[@]} -n 1) - 1 ))]}."
  echo -n "${RANDOM_IP[$(( $(shuf -i 1-${#RANDOM_IP[@]} -n 1) - 1 ))]}."
  echo -n "${RANDOM_IP[$(( $(shuf -i 1-${#RANDOM_IP[@]} -n 1) - 1 ))]}"
}

function gen_url {
  local rand_url="$(( $(shuf -i 1-${#RANDOM_URL[@]} -n 1) - 1 ))"
  local rand_file="$(( $(shuf -i 1-${#RANDOM_FILES[@]} -n 1) - 1 ))"

  echo "${RANDOM_URL[$rand_url]}${RANDOM_FILES[$rand_file]}"
}

function gen_sec {
  local add_sec_max=""
  local add_sec=""

  add_sec_max="$(( 86400 / (MAX_ENTRIES) ))"
  add_sec="$(shuf -i 0-$add_sec_max -n 1)"

  echo "$add_sec"
}

function pick_method {
  local rand="$(( $(shuf -i 1-${#REQUEST_METHODS_5[@]} -n 1) - 1 ))"

  echo "${REQUEST_METHODS_5[$rand]}"
}

function pick_status {
  local rand="$(( $(shuf -i 1-${#STATUS_CODES_6[@]} -n 1) - 1 ))"

  echo "${STATUS_CODES_6[$rand]}"
}

function pick_agent {
  local rand="$(( $(shuf -i 1-${#USER_AGENTS_9[@]} -n 1) - 1 ))"

  echo "${USER_AGENTS_9[$rand]}"
}

function create_entries {
  local entries=""
  local new_date=""

  entries="$(shuf -i ${MIN_ENTRIES}-${MAX_ENTRIES} -n 1)"
  new_date="$2"
  
  for (( j=0; j<entries; j++ ))
  do
    new_date="$(date -d "$new_date + $(gen_sec) seconds")"
    echo "$($IP_GEN_FUNC) - - [$(date -d "$new_date" '+%d/%b/%Y:%T %z')] \"$(pick_method) $(gen_url) HTTP/1.$(shuf -i 0-1 -n 1)\" $(pick_status) $(shuf -i 100-100000 -n 1) \"-\" \"$(pick_agent)\"" >> "$1"
  done
  
  echo -e "INFO:\n\t$logfile_path: $entries entries created"
}

function create_logfile {
  if [ ! -d "$LOG_FILE_PATH" ]
  then
    mkdir "$LOG_FILE_PATH"
  fi

  if [ -d "$LOG_FILE_PATH" ]
  then
    local logfile_path="${LOG_FILE_PATH}/nginx_log_${1}.log"
    touch "$logfile_path" 2>/dev/null

    if [ ! -f "$logfile_path" ]
    then
      echo -e "ERROR:\n\tFile $logfile_path can not be created"
      exit 1
    else
      > "$logfile_path"
      create_entries "$logfile_path" "$2"
    fi
  else
    echo -e "ERROR:\n\tInvalid logpath, can't create ($LOG_FILE_PATH)"
    exit 1
  fi
}

function create_all {
  local log_date=""
  log_date="$(date -d "$DATE_START + $(shuf -i 1-$DATE_RANGE_START -n 1) days" +'%Y-%m-%d')"

  for (( i=1; i <= LOG_FILE_COUNT; i++ ))
  do
    create_logfile "$i" "$log_date"
    log_date="$(date -d "$log_date + $(shuf -i 1-$DATE_RANGE_BETWEEN -n 1) days" +'%Y-%m-%d')"
  done
}
