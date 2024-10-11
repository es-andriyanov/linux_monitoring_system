## Part 7. **Prometheus** и **Grafana**

Практика с логами пока что окончена. Теперь пришло время мониторить состояние системы в целом.

**== Задание ==**

1. Установи и настрой **Prometheus** и **Grafana** на виртуальную машину.
  - Устанавливаем **Prometheus** `sudo apt instal prometheus`
  - Устанавливаем **Grafana** `sudo snap install grafana`
  - Проверка работы **Prometheus** (`systemctl status prometheus`):
  ![1_1](misc/images/1_1.png "")

2. Получи доступ к веб-интерфейсам **Prometheus** и **Grafana** с локальной машины.
  - Проброс портов до виртуальной машины:
  ![2_1](misc/images/2_1.png "")
    - `3000` - до Grafana
    - `9090` - до Prometheus
  - Интерфейс Prometheus с локальной машины:
  ![2_2](misc/images/2_2.png "")
  - Интерфейс Grafana с локальной машины:
  ![2_3](misc/images/2_3.png "")

3. Добавь на дашборд **Grafana** отображение ЦПУ, доступной оперативной памяти, свободное место и кол-во операций ввода/вывода на жестком диске.
  - Добавляем новый источник данных: `Configuration -> Data Sources -> Prometheus`
  ![3_1](misc/images/3_1.png "")
  - В **URL** вводим адрес `http://localhost:9090`:
  ![3_2](misc/images/3_2.png "")
  - Создаем новый дашборд (`New Dashboard -> Add Query`) и добавляем:
    - `sum(rate(node_cpu_seconds_total{mode!="idle"}[30s])) * 100` - отображение загрузки процессора (CPU), все режимы, кроме простоя системы
    ![3_3](misc/images/3_3.png "")
    ![3_4](misc/images/3_4.png "")
    - `node_filesystem_avail_bytes{fstype=~"ext4|xfs"} / 1024 / 1024` - свободные Mb в файловой системе
    ![3_5](misc/images/3_5.png "")
    ![3_6](misc/images/3_6.png "")
    - `node_memory_MemAvailable_bytes/1024/1024` - свободной оперативной памяти в Mb
    ![3_7](misc/images/3_7.png "")
    ![3_8](misc/images/3_8.png "")
    - `rate(node_disk_reads_completed_total[5m])` - I/O READ
    - `irate(node_disk_writes_completed_total[5m])`- I/O WRITE
    ![3_9](misc/images/3_9.png "")
    ![3_10](misc/images/3_10.png "")
    ![3_11](misc/images/3_11.png "")

4. Запусти свой bash-скрипт из [Части 2](#part-2-засорение-файловой-системы). Посмотри на нагрузку жесткого диска (место на диске и операции чтения/записи).
  - До запуска скрипта 02:
  ![3_13_before](misc/images/3_13.png "")
  - После запуска скрипта 02 (рост использования CPU и записей на диск, падение доступной оперативной памяти и свободной памяти на диске - все выделено на скриншоте):
  ![3_12_after](misc/images/3_12.png "")

5. Установи утилиту **stress** и запусти команду `stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s`. Посмотри на нагрузку жесткого диска, оперативной памяти и ЦПУ.
  - До запуска утилиты `stress` (масштаб для наглядности уменьшен до 1 часа):
  ![5_1](misc/images/5_1.png "")
  - Запуск утилиты `stress`:
  ![5_2](misc/images/5_2.png "")
  - После запуска утилиты `stress`:
  ![5_3](misc/images/5_3.png "")
