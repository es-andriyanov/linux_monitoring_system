#!/bin/bash

function print_usage {
  echo -e "USAGE:"
  echo -e "\t./main.sh (PATH/)"
}

function get_all_folders {
  find "$1" -type d | wc -l
}

function get_top5_folders {
  du "$1"* -h --exclude='*.md' | sort -hr | head -n 5 | awk '{print NR " - " $2 ", " $1}'
}

function get_all_files {
  find "$1" -type f | wc -l
}

function get_conf_files {
  find "$1" -type f -name "*.conf" | wc -l
}

function get_text_files {
  find "$1" -type f -name "*.txt" | wc -l
}

function get_exe_files {
  find "$1" -type f -executable | wc -l
}

function get_log_files {
  find "$1" -type f -name "*.log" | wc -l
}

function get_arch_files {
  find "$1" -type f -exec file {} \; | awk '/compressed|archive/' | wc -l
}

function get_symb_files {
  find "$1" -type l | wc -l
}

function get_top10_files {
  find "$1" -type f -exec du -Sh {} + | sort -hr | head -n 10 | awk '{printf "%d - %s, %s, ", NR, $2, $1; system("file --mime-type -b " $2) }'
}

function get_top10_exe_files {
  find "$1" -type f -executable -exec du -Sh {} + | sort -hr | head -n 10 | awk '{printf "%d - %s, %s, ", NR, $2, $1; system("md5sum " $2 " | head -c 32"); printf "\n" }'
}

function get_time_spent {
  time_end="$(date +%s.%N)"

  echo "$time_end-$1" | bc | awk '{ printf "%.3f", $0 }'
}

function print_result {
  echo "Total number of folders (including all nested ones) = $(get_all_folders "$1")"
  echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
  get_top5_folders "$1"
  echo "Total number of files = $(get_all_files "$1")"
  echo "Number of:"
  echo "Configuration files (with the .conf extension) = $(get_conf_files "$1")"
  echo "Text files = $(get_text_files "$1")"
  echo "Executable files = $(get_exe_files "$1")"
  echo "Log files (with the extension .log) = $(get_log_files "$1")"
  echo "Archive files = $(get_arch_files "$1")"
  echo "Symbolic links = $(get_symb_files "$1")"
  echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
  get_top10_files "$1"
  echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
  get_top10_exe_files "$1"
  echo "Script execution time (in seconds) = $(get_time_spent "$2")"
}
