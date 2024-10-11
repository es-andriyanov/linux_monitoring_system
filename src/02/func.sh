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

function print_params {
  echo "HOSTNAME = $(get_hostname)"
  echo "TIMEZONE = $(get_timezone)"
  echo "USER = $(get_user)"
  echo "OS = $(get_os)"
  echo "DATE = $(get_date)"
  echo "UPTIME = $(get_uptime)"
  echo "UPTIME_SEC = $(get_uptime_sec)"
  echo "IP = $(get_ip)"
  echo "MASK = $(get_mask)"
  echo "GATEWAY = $(get_gateway)"
  echo "RAM_TOTAL = $(get_ram_total)"
  echo "RAM_USED = $(get_ram_used)"
  echo "RAM_FREE = $(get_ram_free)"
  echo "SPACE_ROOT = $(get_space_root)"
  echo "SPACE_ROOT_USED = $(get_space_root_used)"
  echo "SPACE_ROOT_FREE = $(get_space_root_free)"
}
