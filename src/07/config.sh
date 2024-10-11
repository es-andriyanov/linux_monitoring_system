#!/bin/bash

FILES=("func.sh" "validation.sh" "config.sh")
LOG_FILE_NAME="02_logs.log"

FORBIDDEN=".*\/(bin|sbin|proc|sys).*"
MAX_PATH_RANGE=20
LIMIT_MB=1000

REGEX_NUM_MB="^(0|([1-9][0-9]*))Mb$"

REGEX_ONLY_SYM_FOLDERS="^[a-zA-Z]{1,7}$"
REGEX_NOREPEAT_FOLDERS="^[a-zA-Z]*([a-zA-Z])\1[a-zA-Z]*$"

REGEX_ONLY_SYM_FILES="^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$"
REGEX_NOREPEAT_FILES="^([a-zA-Z]*([a-zA-Z])\2[a-zA-Z]*)|(\.[a-zA-Z]*([a-zA-Z])\4[a-zA-Z]*)$"

MAX_FILES_NUM=30

NUM=$#
FOLDER_NAME_1=$1
FILES_NAME_2=$2
FILES_SIZE_3=$3
