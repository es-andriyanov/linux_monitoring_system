#!/bin/bash

NUM=$#

source "./validation.sh"

function cpu_usage {
  echo "$(top -bn1 | grep '%Cpu(s):' | awk '{ print $2+$4 }')"
}

function ram_usage {
  echo "$(vmstat -s | grep -i 'free memory' | sed 's/ *//' | awk '{ print $1/1024 }')"
}

function hd_vol {
  local res="$(df / -hBM | tail -n 1 | awk '{ print $3 }')"

  echo "${res::-1}"
}

# Script begin:
validate_params
echo -e "INFO:\n\tCollecting metrics..."

while true
do
  echo -e "# HELP my_cpu_usage CPU usage in %\n# TYPE my_cpu_usage gauge\nmy_cpu_usage $(cpu_usage)\n# HELP my_ram_usage RAM usage in Mb\n# TYPE my_ram_usage gauge\nmy_ram_usage $(ram_usage)\n# HELP my_hd_vol HD volume in Mb\n# TYPE my_hd_vol gauge\nmy_hd_vol $(hd_vol)\n" > /var/www/mymetrics/html/metrics.txt
  sleep 3
done
