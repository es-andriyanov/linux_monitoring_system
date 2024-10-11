#!/bin/bash

function validate_params {
  if [[ "$NUM" -gt 0 ]]
  then
    echo -e "ERROR:\n\tScript should take no params, but not ($NUM)"
    print_usage
    exit 1
  fi
}
