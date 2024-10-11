#!/bin/bash

function validate_params {
  if [[ "$NUM" -ne 0 ]]
  then
    echo -e "ERROR:\n\tScript should take NO params, but not ($NUM)"
    exit 1
  fi
}
