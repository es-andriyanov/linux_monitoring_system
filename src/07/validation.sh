#!/bin/bash

function validate_1 {
  # 1. В строке только буквы алфавита в кол-ве от 1 до 7
  # 2. В строке только буквы алфавита, без повторов подряд
  if [[ ! "$FOLDER_NAME_1" =~ $REGEX_ONLY_SYM_FOLDERS ]]
  then
    echo -e "ERROR:\n\t The 1st param ($FOLDER_NAME_1) should have only 1 to 7 a-z or A-Z symbols"
    print_usage
    exit 1
  fi

  if [[ "$FOLDER_NAME_1" =~ $REGEX_NOREPEAT_FOLDERS ]]
  then
    echo -e "ERROR:\n\t The 1st param ($FOLDER_NAME_1) shouldn't have repeats in a row (like aabcd, abccd, abcdddd, ...)"
    print_usage
    exit 1
  fi
}

function validate_2 {
  # 1. В строке только буквы алфавита в кол-ве от 1 до 7, потом точка, потом только буквы алфавита в кол-ве от 1 до 3
  # 2. В строке только буквы алфавита, без повторов подряд
  if [[ ! "$FILES_NAME_2" =~ $REGEX_ONLY_SYM_FILES ]]
  then
    echo -e "ERROR:\n\t The 2nd param ($FILES_NAME_2) should have 1 to 7 a-zA-Z symbols, dot and 1 to 3 a-zA-Z"
    print_usage
    exit 1
  fi

  if [[ "$FILES_NAME_2" =~ $REGEX_NOREPEAT_FILES ]]
  then
    echo -e "ERROR:\n\t The 2nd param ($FILES_NAME_2) shouldn't have repeats in a row (like aabc.abc, abc.abb, aaa.bbb, ...)"
    print_usage
    exit 1
  fi
}

function validate_3 {
  # 1. Параметр - положительное целое число с Mb на конце
  # 2. Параметр <= 100
  if [[ ! "$FILES_SIZE_3" =~ $REGEX_NUM_MB ]]
  then
    echo -e "ERROR:\n\tThe 3rd param should be a size of files in Mb, ($FILES_SIZE_3) - is not a correct number"
    print_usage
    exit 1
  fi

  if [ "${FILES_SIZE_3:0:${#FILES_SIZE_3} - 2}" -gt 100 ]
  then
    echo -e "ERROR:\n\tThe 3rd param, size of files should be less or equal to 100"
    print_usage
    exit 1
  fi
}

function validate_params {
  if [ $NUM -ne 3 ]
  then
    echo -e "ERROR:\n\tScript should take (3) text param, but not ($NUM)"
    print_usage
    exit 1
  fi

  validate_1
  validate_2
  validate_3
}
