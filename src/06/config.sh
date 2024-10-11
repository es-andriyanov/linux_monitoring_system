#!/bin/bash

FILES=("func.sh" "validation.sh" "config.sh")
LOG_FILE_NAME="01_logs.log"

REGEX_NUM="^(0|([1-9][0-9]*))$"
REGEX_NUM_KB="^(0|([1-9][0-9]*))kb$"

REGEX_ONLY_SYM_FOLDERS="^[a-zA-Z]{1,7}$"
REGEX_NOREPEAT_FOLDERS="^[a-zA-Z]*([a-zA-Z])\1[a-zA-Z]*$"

REGEX_ONLY_SYM_FILES="^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$"
REGEX_NOREPEAT_FILES="^([a-zA-Z]*([a-zA-Z])\2[a-zA-Z]*)|(\.[a-zA-Z]*([a-zA-Z])\4[a-zA-Z]*)$"

NUM=$#
PATH_1=$1
FOLDERS_NUM_2=$2
FOLDER_NAME_3=$3
FILES_NUM_4=$4
FILES_NAME_5=$5
FILES_SIZE_6=$6
