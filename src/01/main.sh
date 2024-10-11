#!/bin/bash

source ./func.sh

RESULT="$(parse "$@")"

echo "$RESULT"
