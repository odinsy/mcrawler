# MetricsCrawler

Гем для сбора метрик доменов.

## Installation

* В консоли перейти в директорию, содержащую файлы скрипта
* gem install bundler - установить гем для отслеживания зависимостей в проекте
* bundle install - произойдет установка нужных гемов
* запускать скрипт с помощью команды

## Usage

h2. 1. Команды

---

После установки, запуск краулера будет доступен из командной строки:
<pre>
➜  ~ crawler
Commands:
  crawler help [COMMAND]                         # Describe available commands or one specific command
  crawler init                                   # Generate all the necessary files
  crawler start -d, --dest=DEST -f, --file=FILE  # Start crawling metrics for domains
  crawler version                                # Show version
</pre>

h2. 2. Инициализация

---

Первоначально для работы через конфигурационный файл необходимо запустить команду `crawler init`:

<pre>
[crawler@mcrawler ~]$ crawler init
Generated configuration file: /home/crawler/.config/metrics_crawler/config.yml
</pre>

h2. 3. Конфигурация

---

После запуска crawler init конфигурационный файл можно отредактировать и указать свои пути.
По умолчанию приложение хранит всю информацию во временной директории /tmp/metrics_crawler

<pre>
[crawler@mcrawler ~]$ cat ~/.config/metrics_crawler/config.yml
---
root_path: "/tmp/metrics_crawler"
domains_path: "/tmp/metrics_crawler/domains"
results_path: "/tmp/metrics_crawler/results"
logs_path: "/tmp/metrics_crawler/logs"
nodes:
- http://example.com:8080/
</pre>

* root_path - директория, где предполагается вести работу (сейчас не используется)
* domains_path - (сейчас не используется)
* results_path - (сейчас не используется)
* logs_path - директория, где хранятся логи с ошибками
* nodes - список нод (прокси-серверов), которые планируется использовать. 1 строка вида "- http://example.com:8080/" - 1 нода.

Пример рабочего конфига:

<pre>
➜  ~ cat /home/odianov/.config/metrics_crawler/config.yml            
---
root_path: "/tmp/metrics_crawler"
domains_path: "/tmp/metrics_crawler/domains"
results_path: "/tmp/metrics_crawler/results"
logs_path: "/tmp/metrics_crawler/logs"
nodes:
- http://wls-01.co.spb.ru:3128/
- http://wls-02.co.spb.ru:3128/
- http://wls-03.co.spb.ru:3128/
- http://wls-04.co.spb.ru:3128/
- http://wls-05.co.spb.ru:3128/
- http://wls-06.co.spb.ru:3128/
- http://wls-07.co.spb.ru:3128/
- http://wls-08.co.spb.ru:3128/
- http://wls-09.co.spb.ru:3128/
- http://wls-10.co.spb.ru:3128/

</pre>

h2. 4. Запуск сбора метрик

---

*Общая информация:*
<pre>
➜  ~ crawler help start                      
Usage:
  crawler start -d, --dest=DEST -f, --file=FILE

Options:
  -C, [--config=CONFIG]        # Path to configuration file. Default: /home/odianov/.config/metrics_crawler/config.yml
  -f, --file=FILE              # Domains file.
  -d, --dest=DEST              # Destination for results file.
  -P, [--nodes=one two three]  # Proxies list.

Start crawling metrics for domains
</pre>

*где:*
* -C - путь к конфигурационному файлу. Если указан без аргументов, то настройки считаются из ~/.config/metrics_crawler/config.yml
* -f - файл с доменами
* -d - файл, куда сохранять результат
* -P - список нод (прокси-серверов). После ключа -P передаются явно одна за одной, пример: -P http://wls-01.co.spb.ru:3128 http://wls-02.co.spb.ru:3128

*Пример запуска сбора метрик, используя ноды, заданные в дефолтном конфигурационном файле:*
<pre>
[crawler@mcrawler ~]$ crawler start -f domains -d result.csv -C
Started crawling to /tmp/metrics_crawler/results/201605061806-res.csv
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"nil", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"27ms", :external_links=>"152"}
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.143.241", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"3ms", :external_links=>"532016067"}
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"93.158.134.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"4ms", :external_links=>"1358000"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"12ms", :external_links=>"5846908"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"4ms", :external_links=>"215396550"}
</pre>

*Пример запуска сбора метрик, используя ноды, заданные в указанном конфигурационном файле:*
<pre>
[crawler@mcrawler ~]$ crawler start -f domains -d result.csv -C config.yml
Started crawling to /tmp/metrics_crawler/results/201605061807-res.csv
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.120", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"3ms", :external_links=>"532016067"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"4ms", :external_links=>"215396550"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"13ms", :external_links=>"5846908"}
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"27ms", :external_links=>"152"}
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"213.180.204.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"4ms", :external_links=>"1358000"}
</pre>

*Пример запуска сбора метрик, используя аргументы командной строки:*
<pre>
[crawler@mcrawler ~]$ crawler start -f domains -d results.csv -P http://wls-01.co.spb.ru:3128 http://wls-02.co.spb.ru:3128 http://wls-03.co.spb.ru:3128
Started crawling to tmp/results.csv
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"213.180.193.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"5ms", :external_links=>"1358000"}
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.117", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"6ms", :external_links=>"532016067"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"16ms", :external_links=>"5846908"}
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"28ms", :external_links=>"152"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"5ms", :external_links=>"215396550"}
</pre>
