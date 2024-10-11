#!/bin/bash

function validate_params {
  if [[ "$NUM" != 1 ]]
  then
    echo -e "ERROR:\n\tScript should take ONE param, but not ($NUM)"
    print_usage
    exit 1
  fi

  if [ -z "$(ls $LOG_FILE_PATH)" ]
  then
    echo -e "ERROR:\n\tThere are no logs in ($LOG_FILE_PATH)"
    print_usage
    exit 1
  fi
}
