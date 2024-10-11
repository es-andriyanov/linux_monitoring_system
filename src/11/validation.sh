#!/bin/bash

function validate_params {
  if [[ "$NUM" -gt 0 ]]
  then
    echo -e "ERROR:\n\tScript should take no params, but not ($NUM)"
    exit 1
  fi
}
