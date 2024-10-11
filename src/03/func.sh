#!/bin/bash

function convert_mask {
  set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
  [ "$1" -gt 1 ] && shift "$1" || shift

  echo "${1-0}"."${2-0}"."${3-0}"."${4-0}"
}

function get_hostname {
  hostname
}

function get_timezone {
  local timezone_name
  local delta_utc

  timezone_name=$(cat /etc/timezone)
  delta_utc=$(date +%:::z)

  echo "$timezone_name UTC $delta_utc"
}

function get_user {
  whoami
}

function get_os {
  lsb_release -d | awk '{$1=""; $0=$0; $1=$1; print}'
}

function get_date {
  date +"%d %B %Y %T"
}

function get_filename {
  date +"%d_%m_%y_%H_%M_%S.status"
}

function get_uptime {
  uptime -p | cut -c 4-
}

function get_uptime_sec {
  < /proc/uptime cut -d. -f '1'
}

function get_ip {
  hostname -I | cut -d' ' -f '1'
}

function get_mask {
  local ip_and_mask
  local cidr_mask

  ip_and_mask="$(ip -o -f inet addr show | awk '{print $4}' | grep "$(get_ip)")"
  cidr_mask=$(echo "$ip_and_mask" | cut -d'/' -f 2)

  convert_mask "$cidr_mask"
}

function get_gateway {
  local gateway

  gateway=$(ip r show default | tail -1 | awk '{print $3}') 

  echo "$gateway"
}

function get_ram_total {
  local ram_gb_total

  ram_gb_total="$(free --kilo | grep Mem: | awk '{printf "%.3f GB", $2/1000/1000}')"

  echo "$ram_gb_total"
}

function get_ram_used {
  local ram_gb_used

  ram_gb_used="$(free --kilo | grep Mem: | awk '{printf "%.3f GB", $3/1000/1000}')"

  echo "$ram_gb_used"
}

function get_ram_free {
  local ram_gb_free

  ram_gb_free="$(free --kilo | grep Mem: | awk '{printf "%.3f GB", $4/1000/1000}')"

  echo "$ram_gb_free"
}

function get_space_root {
  local root_mb_total

  root_mb_total="$(df "/" | tail -1 | awk '{printf "%.2f MB", $2/1000}')"

  echo "$root_mb_total"
}

function get_space_root_used {
  local root_mb_used

  root_mb_used="$(df "/" | tail -1 | awk '{printf "%.2f MB", $3/1000}')"

  echo "$root_mb_used"
}

function get_space_root_free {
  local root_mb_free

  root_mb_free="$(df "/" | tail -1 | awk '{printf "%.2f MB", $4/1000}')"

  echo "$root_mb_free"
}

function get_background {
  background=("\033[107m" "\033[41m" "\033[42m" "\033[44m" "\033[45m" "\033[40m")

  echo "${background[$1-1]}"
}

function get_text {
  text=("\033[97m" "\033[31m" "\033[32m" "\033[34m" "\033[35m" "\033[30m")

  echo "${text[$1-1]}"
}

function print_params {
  echo -e "$1$2HOSTNAME\033[0m = $3$4$(get_hostname)\033[0m"
  echo -e "$1$2TIMEZONE\033[0m = $3$4$(get_timezone)\033[0m"
  echo -e "$1$2USER\033[0m = $3$4$(get_user)\033[0m"
  echo -e "$1$2OS\033[0m = $3$4$(get_os)\033[0m"
  echo -e "$1$2DATE\033[0m = $3$4$(get_date)\033[0m"
  echo -e "$1$2UPTIME\033[0m = $3$4$(get_uptime)\033[0m"
  echo -e "$1$2UPTIME_SEC\033[0m = $3$4$(get_uptime_sec)\033[0m"
  echo -e "$1$2IP\033[0m = $3$4$(get_ip)\033[0m"
  echo -e "$1$2MASK\033[0m = $3$4$(get_mask)\033[0m"
  echo -e "$1$2GATEWAY\033[0m = $3$4$(get_gateway)\033[0m"
  echo -e "$1$2RAM_TOTAL\033[0m = $3$4$(get_ram_total)\033[0m"
  echo -e "$1$2RAM_USED\033[0m = $3$4$(get_ram_used)\033[0m"
  echo -e "$1$2RAM_FREE\033[0m = $3$4$(get_ram_free)\033[0m"
  echo -e "$1$2SPACE_ROOT\033[0m = $3$4$(get_space_root)\033[0m"
  echo -e "$1$2SPACE_ROOT_USED\033[0m = $3$4$(get_space_root_used)\033[0m"
  echo -e "$1$2SPACE_ROOT_FREE\033[0m = $3$4$(get_space_root_free)\033[0m"
}

function print_usage {
  echo -e "USAGE:"
  echo -e "\t./main.sh (COL1_BACKGROUND) (COL1_TEXT) (COL2_BACKGROUND) (COL2_TEXT)"
  echo -e "COLOR CODES:"
  echo -e "\t1 - white, 2 - red, 3 - green, 4 - blue, 5 – purple, 6 - black"
}
