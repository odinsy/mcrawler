# MetricsCrawler

[![Build Status](https://travis-ci.org/odinsy/metrics_crawler.svg?branch=master)](https://travis-ci.org/odinsy/metrics_crawler)

Гем для сбора метрик доменов.

## Installation

* В консоли перейти в директорию, содержащую файлы скрипта
* gem install bundler - установить гем для отслеживания зависимостей в проекте
* bundle install - произойдет установка нужных гемов
* запускать скрипт с помощью команды

## Usage

### CLI

---
```
➜  ~ crawler
Commands:
  crawler help [COMMAND]                         # Describe available commands or one specific command
  crawler init                                   # Generate all the necessary files
  crawler start -d, --dest=DEST -f, --file=FILE  # Start crawling metrics for domains
  crawler version                                # Show version
```

### Инициализация

---

Первоначально для работы через конфигурационный файл необходимо запустить команду `crawler init`:

```
[crawler@mcrawler ~]$ crawler init
Generated configuration file: /home/crawler/.config/metrics_crawler/config.yml
```

### Конфигурация

---

После инициализации конфигурационный файл можно отредактировать и указать свои пути.
По умолчанию приложение хранит всю информацию во временной директории /tmp/metrics_crawler

```
[crawler@mcrawler ~]$ cat ~/.config/metrics_crawler/config.yml
---
root_path: "/tmp/metrics_crawler"
domains_path: "/tmp/metrics_crawler/domains"
results_path: "/tmp/metrics_crawler/results"
logs_path: "/tmp/metrics_crawler/logs"
nodes:
- http://node01.example.org:3128/
- http://node02.example.org:3128/
```

* root_path - директория, где предполагается вести работу (сейчас не используется)
* domains_path - (сейчас не используется)
* results_path - (сейчас не используется)
* logs_path - директория, где хранятся логи с ошибками
* nodes - список нод (прокси-серверов), которые планируется использовать. 1 строка вида "- http://node01:3128/" - 1 нода.


### Запуск сбора метрик

---

*Общая информация:*
```
➜  ~ crawler help start                      
Usage:
  crawler start -d, --dest=DEST -f, --file=FILE

Options:
  -C, [--config=CONFIG]        # Path to configuration file. Default: /home/odianov/.config/metrics_crawler/config.yml
  -f, --file=FILE              # Domains file.
  -d, --dest=DEST              # Destination for results file.
  -P, [--nodes=one two three]  # Proxies list. Example: -P http://node01.example.org:3128 http://node02.example.org:3128

Start crawling metrics for domains
```

*где:*
* -C - путь к конфигурационному файлу. Если указан без аргументов, то настройки считаются из ~/.config/metrics_crawler/config.yml
* -f - файл с доменами
* -d - файл, куда сохранять результат
* -P - список нод (прокси-серверов).

### Примеры запуска

---

*Пример запуска сбора метрик, используя ноды, заданные в дефолтном конфигурационном файле:*
```
[crawler@mcrawler ~]$ crawler start -f domains -d result.csv -C
Started crawling to result.csv
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"nil", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"27ms", :external_links=>"152"}
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.143.241", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"3ms", :external_links=>"532016067"}
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"93.158.134.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"4ms", :external_links=>"1358000"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"12ms", :external_links=>"5846908"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"4ms", :external_links=>"215396550"}
```

*Пример запуска сбора метрик, используя ноды, заданные в указанном конфигурационном файле:*
```
[crawler@mcrawler ~]$ crawler start -f domains -d result.csv -C config.yml
Started crawling to result.csv
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.120", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"3ms", :external_links=>"532016067"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"4ms", :external_links=>"215396550"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"13ms", :external_links=>"5846908"}
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"27ms", :external_links=>"152"}
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"213.180.204.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"4ms", :external_links=>"1358000"}
```

*Пример запуска сбора метрик, используя аргументы командной строки:*
```
[crawler@mcrawler ~]$ crawler start -f domains -d results.csv -P http://node01.example.org:3128 http://node02.example.org:3128 http://node03.example.org:3128
Started crawling to results.csv
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"213.180.193.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"5ms", :external_links=>"1358000"}
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.117", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"6ms", :external_links=>"532016067"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"16ms", :external_links=>"5846908"}
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"28ms", :external_links=>"152"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"5ms", :external_links=>"215396550"}
```
