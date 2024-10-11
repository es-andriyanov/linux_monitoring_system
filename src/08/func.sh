#!/bin/bash

function print_usage {
  echo -e "USAGE:\n\t./main.sh 1\n"
  echo -e "\t1  - delete by logfile"
  echo -e "\t11 - (safe) only print files deleting by logfile"
  echo -e "\t2  - delete by creation time (ex.: ./main.sh 2 \"2024-12-31 23:58\" \"2024-12-31 23:59\")"
  echo -e "\t22 - (safe) only print files deleting by creation time"
  echo -e "\t3  - delete by name"
  echo -e "\t33 - (safe) only print files deleting by name"
}

function print_working_time {
  local durationtime="$(( ($2 - $1) / 1000000))"

  echo -e "START:\t[$(date -d"@${1::-9}" '+%d/%b/%Y:%T %z')]"
  echo -e "FREE:\t$3 Mb"
  echo -e "END:\t[$(date -d"@${2::-9}" '+%d/%b/%Y:%T %z')]"
  echo -e "FREE:\t$4 Mb"
  echo -e "DUR:\t${durationtime} ms"
  echo -e "DEL:\t$5 files, $6 folders"
}

function space_available {
  space_MB="$(df -BMB / | awk '{print $4}' | sed -n 2p)"
  space_MB="${space_MB:0:${#space_MB} - 2}"

  echo "$space_MB"
}

function logger {
  echo -e "${1}\t${2}\t${3}" >> "$LOG_FILE_NAME"
}

function delete_1 {
  # Looking for logfile:
  if [ ! -f "$LOG_FILE_NAME" ]
  then
    echo -e "ERROR:\n\tCan't find logfile ($LOG_FILE_NAME)"
    exit 1
  fi

  # Deleting files
  echo -e "INFO:\n\tFound logfile ($LOG_FILE_NAME). Deleting files and folders by it"
  for ffile in $(awk '{print length($1),$1}' $LOG_FILE_NAME | sort -k1nr | awk '{print $2}')
  do
    if [ -f "$ffile" ]
    then
      rm -rf "$ffile"
      if [ ! -f "$ffile" ]
      then
        ((files_deleted++))
      fi
    fi
  done

  # Deleting dirs
  for ddir in $(awk '{print length($1),$1}' $LOG_FILE_NAME | sort -k1nr | awk '{print $2}')
  do
    if [ -d "$ddir" ]
    then
      rm -rf "$ddir"
      if [ ! -d "$ddir" ]
      then
        ((folders_deleted++))
      fi
    fi
  done
}

function delete_2 {
  echo -e "INFO:\n\tDeleting files and folders by creation time"
  local ls_i=""
  local df_T=""
  local deb_crtime=""
  local deb_mtime=""
  local diff=100000
  local crtime_sec=""
  local mtime_sec=""
  local log_p=""
  local mdirs=()

  log_p="$(realpath $LOG_FILE_NAME)"

  # Deleting dirs
  for ddir in $(find / -type d -newermt "$START_DATE_2" ! -newermt "$END_DATE_3" 2>/dev/null)
  do
    if [ -d "$ddir" ]
    then
      ls_i="$(ls -id "$ddir" | awk '{print $1}')"
      df_T="$(df -T "$ddir" | awk '{print $1}' | tail -n 1)"
      deb_crtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*crtime:" | awk '{$1=$2=$3=""; print $0}')"
      deb_mtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*mtime:" | awk '{$1=$2=$3=""; print $0}')"
      crtime_sec="$(date -d"$deb_crtime" +%s 2>/dev/null)"
      mtime_sec="$(date -d"$deb_mtime" +%s 2>/dev/null)"

      if [[ (-n $crtime_sec) && (-n $mtime_sec) ]]
      then
        diff="$(( crtime_sec - mtime_sec ))"
      fi

      if [[ ($diff -lt $SEC_DELAY) && (-n "$deb_crtime") && (-n "$deb_mtime") ]]
      then
        mdirs+=( "$ddir" )
      fi
    fi
  done

  ls_i=""
  df_T=""
  deb_crtime=""
  deb_mtime=""
  diff=100000
  crtime_sec=""
  mtime_sec=""

  # Deleting files
  for ffile in $(find / -type f -newermt "$START_DATE_2" ! -newermt "$END_DATE_3" 2>/dev/null)
  do
    if [[ (-f "$ffile") && ("$ffile" != "$log_p") ]]
    then
      ls_i="$(ls -i "$ffile" | awk '{print $1}')"
      df_T="$(df -T "$ffile" | awk '{print $1}' | tail -n 1)"
      deb_crtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*crtime:" | awk '{$1=$2=$3=""; print $0}')"
      deb_mtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*mtime:" | awk '{$1=$2=$3=""; print $0}')"
      crtime_sec="$(date -d"$deb_crtime" +%s 2>/dev/null)"
      mtime_sec="$(date -d"$deb_mtime" +%s 2>/dev/null)"

      if [[ (-n $crtime_sec) && (-n $mtime_sec) ]]
      then
        diff="$(( crtime_sec - mtime_sec ))"
      fi

      if [[ ($diff -lt $SEC_DELAY) && (-n "$deb_crtime") && (-n "$deb_mtime") ]]
      then
        rm -rf "$ffile"
        if [ ! -f "$ffile" ]
        then
          ((files_deleted++))
        fi
      fi
    fi
  done

  #Del dirs
  for m in "${mdirs[@]}"; do
    rm -rf "$m"

    if [ ! -d "$m" ]
    then
      ((folders_deleted++))
    fi
  done
}

function delete_3 {
  echo -e "INFO:\n\tDeleting files and folders by name (ex.: ABC_011224, abc_011224.qwe)"

  for ffile in $(find / -regex "$REGEX_FILES" | awk '{print length($1),$1}' | sort -k1nr | awk '{print $2}')
  do
    if [ -f "$ffile" ]
    then
      rm -rf "$ffile"
      if [ ! -f "$ffile" ]
      then
        ((files_deleted++))
      fi
    fi
  done

  for ddir in $(find / -regex "$REGEX_FOLDERS" | awk '{print length($1),$1}' | sort -k1nr | awk '{print $2}')
  do
    if [ -d "$ddir" ]
    then
      rm -rf "$ddir"
      if [ ! -d "$ddir" ]
      then
        ((folders_deleted++))
      fi
    fi
  done
}

function delete_1_safe {
  # Looking for logfile:
  if [ ! -f "$LOG_FILE_NAME" ]
  then
    echo -e "ERROR:\n\tCan't find logfile ($LOG_FILE_NAME)"
    exit 1
  fi

  local num=1

  # Printing files and dirs
  echo -e "INFO:\n\t(SAFE) Found logfile ($LOG_FILE_NAME). Printing files and folders by it"
  # echo -e "FOLDERS:"
  # echo "$(awk '$4 == "-" {print length($1),$1}' $LOG_FILE_NAME | sort -k1n | awk '{print $2}' | grep -n ".*")"
  # echo -e "FILES:"
  # echo "$(awk '$4 != "-" {print length($1),$1}' $LOG_FILE_NAME | sort -k1n | awk '{print $2}' | grep -n ".*")"

  # Printing dirs
  echo -e "FOLDERS:"
  for dddir in $(awk '{print length($1),$1}' $LOG_FILE_NAME | sort -k1n | awk '{print $2}')
  do
    if [ -d "$dddir" ]
    then
      echo "$num:$dddir"
      ((num++))
    fi
  done

  num=1

  # Printing files
  echo -e "FILES:"
  for fffile in $(awk '{print length($1),$1}' $LOG_FILE_NAME | sort -k1n | awk '{print $2}')
  do
    if [ -f "$fffile" ]
    then
      echo "$num:$fffile"
      ((num++))
    fi
  done


}

function delete_2_safe {
  echo -e "INFO:\n\t(SAFE) Printing files and folders by creation time"
  local ls_i=""
  local df_T=""
  local deb_crtime=""
  local deb_mtime=""
  local num=1
  local diff=100000
  local crtime_sec=""
  local mtime_sec=""
  local log_p=""

  log_p="$(realpath $LOG_FILE_NAME)"

  # Printing dirs
  echo -e "FOLDERS:"
  for ddir in $(find / -type d -newermt "$START_DATE_2" ! -newermt "$END_DATE_3" 2>/dev/null | awk '{print length($1),$1}' | sort -k1n | awk '{print $2}' )
  do
    if [[ (-d "$ddir") && ("$ddir" != "$log_p") ]]
    then
      ls_i="$(ls -id "$ddir" | awk '{print $1}')"
      df_T="$(df -T "$ddir" | awk '{print $1}' | tail -n 1)"
      deb_crtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*crtime:" | awk '{$1=$2=$3=""; print $0}')"
      deb_mtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*mtime:" | awk '{$1=$2=$3=""; print $0}')"
      crtime_sec="$(date -d"$deb_crtime" +%s 2>/dev/null)"
      mtime_sec="$(date -d"$deb_mtime" +%s 2>/dev/null)"

      if [[ (-n $crtime_sec) && (-n $mtime_sec) ]]
      then
        diff="$(( mtime_sec - crtime_sec ))"
      fi

      if [[ ($diff -lt $SEC_DELAY) ]]
      then
        echo -e "$num:$ddir"
        ((num++))
      fi
    fi
  done

  ls_i=""
  df_T=""
  deb_crtime=""
  deb_mtime=""
  num=1
  diff=100000
  crtime_sec=""
  mtime_sec=""

  # Printing files
  echo -e "FILES:"
  for ffile in $(find / -type f -newermt "$START_DATE_2" ! -newermt "$END_DATE_3" 2>/dev/null | awk '{print length($1),$1}' | sort -k1n | awk '{print $2}')
  do
    if [[ (-f "$ffile") && ("$ffile" != "$log_p") ]]
    then
      ls_i="$(ls -i "$ffile" | awk '{print $1}')"
      df_T="$(df -T "$ffile" | awk '{print $1}' | tail -n 1)"
      deb_crtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*crtime:" | awk '{$1=$2=$3=""; print $0}')"
      deb_mtime="$(debugfs -R "stat <$ls_i>" "$df_T" 2>/dev/null | grep ".*mtime:" | awk '{$1=$2=$3=""; print $0}')"
      crtime_sec="$(date -d"$deb_crtime" +%s 2>/dev/null)"
      mtime_sec="$(date -d"$deb_mtime" +%s 2>/dev/null)"

      if [[ (-n $crtime_sec) && (-n $mtime_sec) ]]
      then
        diff="$(( mtime_sec - crtime_sec ))"
      fi

      if [[ ($diff -lt $SEC_DELAY) ]]
      then
        echo -e "$num:$ffile"
        ((num++))
      fi
    fi
  done
}

function delete_3_safe {
  echo -e "INFO:\n\t(SAFE) printing files and folders by name (ex.: ABC_011224, abc_011224.qwe)"
  
  echo -e "FOLDERS:"
  find / -regex "$REGEX_FOLDERS" 2>/dev/null | awk '{print length($1),$1}' | sort -k1n | awk '{print $2}' | grep -n ".*"
  echo -e "FILES:"
  find / -regex "$REGEX_FILES" 2>/dev/null | awk '{print length($1),$1}' | sort -k1n | awk '{print $2}' | grep -n ".*"
}


function delete_all {
  if [[ "$WAY_1" == 1 ]]
  then
    delete_1
  elif [[ "$WAY_1" == 2 ]]
  then
    delete_2
  elif [[ "$WAY_1" == 3 ]]
  then
    delete_3
  elif [[ "$WAY_1" == 11 ]]
  then
    delete_1_safe
  elif [[ "$WAY_1" == 22 ]]
  then
    delete_2_safe
  elif [[ "$WAY_1" == 33 ]]
  then
    delete_3_safe
  else
    echo -e "ERROR:\t\nUnknown way"
  fi
}
