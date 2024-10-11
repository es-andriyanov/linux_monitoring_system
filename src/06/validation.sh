#!/bin/bash

function validate_1 {
  # 1. Слэш в начале
  # 2. Путь существует
  if [ "${PATH_1:0:1}" != "/" ]
  then 
    echo -e "ERROR:"
    echo -e "\tPATH should starts with /"
    print_usage
    exit 1
  fi

  if [ ! -d "$PATH_1" ]
  then
    echo -e "ERROR:\n\tDirectory by the PATH ($PATH_1) doesn't exist"
    print_usage
    exit 1
  fi
}

function validate_2 {
  # 1. Параметр - положительное целое число
  # 2. Параметр больше 0
  if [[ ! "$FOLDERS_NUM_2" =~ $REGEX_NUM ]]
  then
    echo -e "ERROR:\n\tThe 2nd param should be a number of folders, ($FOLDERS_NUM_2) - is not a correct number"
    print_usage
    exit 1
  fi

  if [ "$FOLDERS_NUM_2" == 0 ]
  then
    echo -e "ERROR:\n\tThe 2th param, number of folders should be greater than 0"
    print_usage
    exit 1
  fi
}

function validate_3 {
  # 1. В строке только буквы алфавита в кол-ве от 1 до 7
  # 2. В строке только буквы алфавита, без повторов подряд
  if [[ ! "$FOLDER_NAME_3" =~ $REGEX_ONLY_SYM_FOLDERS ]]
  then
    echo -e "ERROR:\n\t The 3rd param ($FOLDER_NAME_3) should have only 1 to 7 a-z or A-Z symbols"
    print_usage
    exit 1
  fi

  if [[ "$FOLDER_NAME_3" =~ $REGEX_NOREPEAT_FOLDERS ]]
  then
    echo -e "ERROR:\n\t The 3rd param ($FOLDER_NAME_3) shouldn't have repeats in a row (like aabcd, abccd, abcdddd, ...)"
    print_usage
    exit 1
  fi
}

function validate_4 {
  # 1. Параметр - положительное целое число
  # 2. Параметр больше 0
  if [[ ! "$FILES_NUM_4" =~ $REGEX_NUM ]]
  then
    echo -e "ERROR:\n\tThe 4th param should be a number of files, ($FILES_NUM_4) - is not a correct number"
    print_usage
    exit 1
  fi

  if [ "$FILES_NUM_4" == 0 ]
  then
    echo -e "ERROR:\n\tThe 4th param, number of files should be greater than 0"
    print_usage
    exit 1
  fi
}

function validate_5 {
  # 1. В строке только буквы алфавита в кол-ве от 1 до 7, потом точка, потом только буквы алфавита в кол-ве от 1 до 3
  # 2. В строке только буквы алфавита, без повторов подряд
  if [[ ! "$FILES_NAME_5" =~ $REGEX_ONLY_SYM_FILES ]]
  then
    echo -e "ERROR:\n\t The 5rd param ($FILES_NAME_5) should have 1 to 7 a-zA-Z symbols, dot and 1 to 3 a-zA-Z"
    print_usage
    exit 1
  fi

  if [[ "$FILES_NAME_5" =~ $REGEX_NOREPEAT_FILES ]]
  then
    echo -e "ERROR:\n\t The 5rd param ($FILES_NAME_5) shouldn't have repeats in a row (like aabc.abc, abc.abb, aaa.bbb, ...)"
    print_usage
    exit 1
  fi
}

function validate_6 {
  # 1. Параметр - положительное целое число с kb на конце
  # 2. Параметр <= 100
  if [[ ! "$FILES_SIZE_6" =~ $REGEX_NUM_KB ]]
  then
    echo -e "ERROR:\n\tThe 6th param should be a size of files, ($FILES_SIZE_6) - is not a correct number"
    print_usage
    exit 1
  fi

  if [ "${FILES_SIZE_6:0:${#FILES_SIZE_6} - 2}" -gt 100 ]
  then
    echo -e "ERROR:\n\tThe 6th param, size of files should be less or equal to 100"
    print_usage
    exit 1
  fi
}

function validate_params {
  if [ $NUM -ne 6 ]
  then
    echo -e "ERROR:\n\tScript should take (6) text param, but not ($NUM)"
    print_usage
    exit 1
  fi

  validate_1
  validate_2
  validate_3
  validate_4
  validate_5
  validate_6
}
