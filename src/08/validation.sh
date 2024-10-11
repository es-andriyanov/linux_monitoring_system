#!/bin/bash

function validate_1 {
  # 1. В строке только число от 1 до 3
  # 2. Если выбран путь 1 (или 11), то 1 параметр
  # 3. Если выбран путь 2 (или 22), то 3 параметра
  # 4. Если выбран путь 3 (или 33), то 1 параметр
  if [[ ! "$WAY_1" =~ $REGEX_1 ]]
  then
    echo -e "ERROR:\n\t The 1st param ($WAY_1) should be a num from 1 to 3"
    print_usage
    exit 1
  fi

  if [[ ("$WAY_1" == "1" || "$WAY_1" == "11") && ("$NUM" != 1)]]
  then
    echo -e "ERROR:\n\t You picked WAY $WAY_1, there should be only 1 param"
    print_usage
    exit 1
  fi

  if [[ ("$WAY_1" == "2" || "$WAY_1" == "22") && ("$NUM" != 3)]]
  then
    echo -e "ERROR:\n\t You picked WAY $WAY_1, there should be 3 params: way, date_start, date_end"
    print_usage
    exit 1
  fi

  if [[ ("$WAY_1" == "3" || "$WAY_1" == "33") && ("$NUM" != 1)]]
  then
    echo -e "ERROR:\n\t You picked WAY $WAY_1, there should be only 1 param"
    print_usage
    exit 1
  fi
}

function validate_2 {
  # 1. Формат 2024-12-31 23:59
  # 2. Дата валидна
  ### Сначала найдем файлы, измененные в промежутке дат, потом исключим файлы, созданные ранее через debugfs, потом удалим папки из промежутка
  if [[ ! "$START_DATE_2" =~ $REGEX_DATE || ! $(date -d "$START_DATE_2") ]]
  then
    echo -e "ERROR:\n\t The 2nd param ($START_DATE_2) should be a valid date, format: 2024-12-31 23:59"
    print_usage
    exit 1
  fi
}

function validate_3 {
  # 1. Формат 2024-12-31 23:59
  # 2. Дата валидна
  if [[ ! "$END_DATE_3" =~ $REGEX_DATE || ! $(date -d "$END_DATE_3") ]]
  then
    echo -e "ERROR:\n\t The 3rd param ($END_DATE_3) should be a valid date, format: 2024-12-31 23:59"
    print_usage
    exit 1
  fi
}

function validate_params {
  if [[ "$NUM" -gt 3 ]]
  then
    echo -e "ERROR:\n\tScript should take max (3) param, but not ($NUM)"
    print_usage
    exit 1
  fi

  validate_1

  if [[ "$WAY_1" == 2 ]]
  then
    validate_2
    validate_3
  fi
}
