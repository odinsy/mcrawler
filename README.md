# MetricsCrawler

Гем для сбора метрик доменов.

## Инструкция по установке

* В консоли перейти в директорию, содержащую файлы скрипта
* gem install bundler - установить гем для отслеживания зависимостей в проекте
* bundle install - произойдет установка нужных гемов
* запускать скрипт с помощью команды

## Запуск краулера.

---

### Команды

---

После установки, запуск краулера будет доступен из командной строки:
<pre>
[crawler@mcrawler ~]$ crawler     
Commands:
  crawler help [COMMAND]         # Describe available commands or one specific command
  crawler init                   # Generate all the necessary files
  crawler split -f, --file=FILE  # Split the domains file.
  crawler start TYPE             # Start crawling. Type can be SOLO or MULTI.
</pre>

### Инициализация

---

Первоначально для работы через конфигурационный файл необходимо запустить команду `crawler init`:

```
[crawler@mcrawler ~]$ crawler init
Generated configuration file: /home/crawler/.config/metrics_crawler/config.yml
```

### Конфигурация

---

После запуска crawler init конфигурационный файл можно отредактировать и указать свои пути.
По умолчанию приложение хранит всю информацию в временной директории /tmp/metrics_crawler

```
[crawler@mcrawler ~]$ cat ~/.config/metrics_crawler/config.yml
---
root_path: "/tmp/metrics_crawler"
domains_path: "/tmp/metrics_crawler/domains"
results_path: "/tmp/metrics_crawler/results"
logs_path: "/tmp/metrics_crawler/logs"
nodes:
- http://example.com:8080/
```

* root_path - директория, где предполагается вести работу (сейчас не используется)
* domains_path - директория, где хранятся входные файлы с доменами, также по умолчанию отсюда будут грузиться файлы с доменами для нод, разделенные ранее с помощью crawler split
* results_path - директория, в которой по умолчанию сохраняются результаты
* logs_path - директория, где хранятся логи (сейчас только с ошибками)
* nodes - список нод (прокси-серверов), которые планируется использовать. 1 строка вида "- http://example.com:8080/" - 1 нода.

Пример рабочего конфига:

```
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
```

### Дробление доменов на количество нод (прокси-серверов)

---

Для дальнейшего запуска сбора метрик в параллельном режиме, предварительно необходимо разбить входящий файл с доменами на количество нод.

*Общая информация:*
```
[crawler@mcrawler ~]$ crawler help split
Usage:
  crawler split -f, --file=FILE

Options:
  -C, [--config=CONFIG]        # Path to configuration file. Default: /home/crawler/.config/metrics_crawler/config.yml
  -f, --file=FILE              # Domains file.
  -d, [--dest=DEST]            # Path to directory where to store splitted files.
  -n, [--nodes=one two three]  # Path to configuration file where declared nodes.

Split the domains file.
```

*Пример дробления, используя параметры, заданные в дефолтном конфигурационном файле:*
```
[crawler@mcrawler ~]$ crawler split -f domains -C
Was created a file with domains for the node wls-01.co.spb.ru: /tmp/metrics_crawler/domains/wls-01.co.spb.ru
Was created a file with domains for the node wls-02.co.spb.ru: /tmp/metrics_crawler/domains/wls-02.co.spb.ru
Was created a file with domains for the node wls-03.co.spb.ru: /tmp/metrics_crawler/domains/wls-03.co.spb.ru
Was created a file with domains for the node wls-04.co.spb.ru: /tmp/metrics_crawler/domains/wls-04.co.spb.ru
Was created a file with domains for the node wls-05.co.spb.ru: /tmp/metrics_crawler/domains/wls-05.co.spb.ru
Was created a file with domains for the node wls-06.co.spb.ru: /tmp/metrics_crawler/domains/wls-06.co.spb.ru
Was created a file with domains for the node wls-07.co.spb.ru: /tmp/metrics_crawler/domains/wls-07.co.spb.ru
Was created a file with domains for the node wls-08.co.spb.ru: /tmp/metrics_crawler/domains/wls-08.co.spb.ru
Was created a file with domains for the node wls-09.co.spb.ru: /tmp/metrics_crawler/domains/wls-09.co.spb.ru
Was created a file with domains for the node wls-10.co.spb.ru: /tmp/metrics_crawler/domains/wls-10.co.spb.ru
```

*Пример дробления, используя параметры, заданные в указанном конфигурационном файле:*
```
[crawler@mcrawler ~]$ crawler split -f domains -C config.yml
Was created a file with domains for the node wls-01.co.spb.ru: /tmp/metrics_crawler/domains/wls-01.co.spb.ru
Was created a file with domains for the node wls-02.co.spb.ru: /tmp/metrics_crawler/domains/wls-02.co.spb.ru
Was created a file with domains for the node wls-03.co.spb.ru: /tmp/metrics_crawler/domains/wls-03.co.spb.ru
Was created a file with domains for the node wls-04.co.spb.ru: /tmp/metrics_crawler/domains/wls-04.co.spb.ru
Was created a file with domains for the node wls-05.co.spb.ru: /tmp/metrics_crawler/domains/wls-05.co.spb.ru
Was created a file with domains for the node wls-06.co.spb.ru: /tmp/metrics_crawler/domains/wls-06.co.spb.ru
Was created a file with domains for the node wls-07.co.spb.ru: /tmp/metrics_crawler/domains/wls-07.co.spb.ru
Was created a file with domains for the node wls-08.co.spb.ru: /tmp/metrics_crawler/domains/wls-08.co.spb.ru
Was created a file with domains for the node wls-09.co.spb.ru: /tmp/metrics_crawler/domains/wls-09.co.spb.ru
Was created a file with domains for the node wls-10.co.spb.ru: /tmp/metrics_crawler/domains/wls-10.co.spb.ru
```

*Пример дробления, используя аргументы командной строки:*
```
[crawler@mcrawler ~]$ crawler split -f domains -d /tmp/metrics_crawler/domains -n http://wls-01.co.spb.ru:3128 http://wls-02.co.spb.ru:3128 http://wls-03.co.spb.ru:3128
Was created a file with domains for the node wls-01.co.spb.ru: /tmp/metrics_crawler/domains/wls-01.co.spb.ru
Was created a file with domains for the node wls-02.co.spb.ru: /tmp/metrics_crawler/domains/wls-02.co.spb.ru
Was created a file with domains for the node wls-03.co.spb.ru: /tmp/metrics_crawler/domains/wls-03.co.spb.ru
```

### Запуск сбора метрик

---

Существует возможность запустить сбор метрик в 2х режимах - одиночном (solo) и параллельном (multi).

### Одиночный режим (solo)

---

*Общая информация:*
```
[crawler@mcrawler ~]$ crawler start help solo
Usage:
  crawler solo -d, --dest=DEST -f, --file=FILE

Options:
  -f, --file=FILE      # Domains file.
  -d, --dest=DEST      # Destination for results file.
  -p, [--proxy=PROXY]  # Proxyname like 'http://proxyname:port/'

Run crawling for domains from file via or without proxy.
```

*где:*
* -s - путь к файлу с доменами
* -d - путь, куда сохранять результат
* -p - прокси-сервер вида http://proxyname:port/, например http://wls-01.co.spb.ru:3128

*Пример запуска, не используя прокси-сервер:*
```
[crawler@mcrawler ~]$ crawler start solo -f domains -d result.csv
Started crawling to result.csv
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.118", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"6ms", :external_links=>"532016067"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"34ms", :external_links=>"215396550"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"216ms", :external_links=>"5846908"}
[crawler@mcrawler ~]$
```

*Пример запуска, используя прокси-сервер:*
```
[crawler@mcrawler ~]$ crawler start solo -f domains -d result.csv -p http://wls-01.co.spb.ru:3128
Started crawling to result.csv
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.143.241", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"6ms", :external_links=>"532016067"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"9ms", :external_links=>"215396550"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"17ms", :external_links=>"5846908"}
[crawler@mcrawler ~]$
```

*Результат:*
```
[crawler@mcrawler ~]$ cat result.csv
url|yandex_catalog|yandex_tic|yandex_index|google_index|google_pagerank|google_backlinks|dmoz_catalog|alexa_rank|host_age|host_ip|host_country|host_from|host_to|download_speed|external_links
vk.com|true|360 000|415 493 859|91 000 000|0|1550|true|20|18 лет 10 месяцев 12 дней|87.240.143.241|Russian Federation|24.06.97|23.06.17|6ms|532016067
google.com|true|310 000|19 968 655|2 760 000 000|0|0|true|1|18 лет 7 месяцев 21 день|216.58.212.174|""|15.09.97|13.09.20|9ms|215396550
bing.com|true|5 800|3 278 304 412|15 100 000|0|0|true|17|20 лет 3 месяца 9 дней|204.79.197.200|""|28.01.96|29.01.19|17ms|5846908
```

### Параллельный режим (multi)

---

*Общая информация:*
```
[crawler@mcrawler ~]$ crawler start help multi
Usage:
  crawler multi

Options:
  -C, [--config=CONFIG]        # Path to configuration file. Default: /home/crawler/.config/metrics_crawler/config.yml
  -s, [--source=SOURCE]        # Path to directory where was stored splitted files.
  -d, [--dest=DEST]            # Destination for results file.
  -N, [--nodes=one two three]  # List of nodes.

Run crawling for domains in a parallel mode.
```

*где:*
* -C - путь к конфигурационному файлу. Если указан без аргументов, то настройки считаются из ~/.config/metrics_crawler/config.yml
* -s - путь, где находятся поделенные ранее с помощью split файлы с доменами
* -d - путь, куда сохранять результат
* -N - список нод (прокси-серверов). После ключа -N передаются явно одна за одной, пример: -N http://wls-01.co.spb.ru:3128 http://wls-02.co.spb.ru:3128

*Подготовка:*
* Для работы через конфигурационный файл предварительно настраиваем в нем все пути и права, также указываем планируемые для использования прокси-сервера.
* С помощью crawler split дробим входящий файл с доменами на количество нод

*Пример запуска сбора метрик в параллельном режиме, используя параметры, заданные в дефолтном конфигурационном файле:*
```
[crawler@mcrawler ~]$ crawler start multi -C
Started crawling to /tmp/metrics_crawler/results/201605061806-res.csv
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"nil", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"27ms", :external_links=>"152"}
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.143.241", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"3ms", :external_links=>"532016067"}
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"93.158.134.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"4ms", :external_links=>"1358000"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"12ms", :external_links=>"5846908"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"4ms", :external_links=>"215396550"}
```

*Пример запуска сбора метрик в параллельном режиме, используя параметры, заданные в указанном конфигурационном файле:*
```
[crawler@mcrawler ~]$ crawler start multi -C config.yml
Started crawling to /tmp/metrics_crawler/results/201605061807-res.csv
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.120", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"3ms", :external_links=>"532016067"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"4ms", :external_links=>"215396550"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"13ms", :external_links=>"5846908"}
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"27ms", :external_links=>"152"}
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"213.180.204.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"4ms", :external_links=>"1358000"}
```

*Пример запуска сбора метрик в параллельном режиме, используя аргументы командной строки:*
```
[crawler@mcrawler ~]$ crawler split -f domains -d tmp -n http://wls-01.co.spb.ru:3128 http://wls-02.co.spb.ru:3128 http://wls-03.co.spb.ru:3128
Was created a file with domains for the node wls-01.co.spb.ru: tmp/wls-01.co.spb.ru
Was created a file with domains for the node wls-02.co.spb.ru: tmp/wls-02.co.spb.ru
Was created a file with domains for the node wls-03.co.spb.ru: tmp/wls-03.co.spb.ru
```

```
[crawler@mcrawler ~]$ crawler start multi -s tmp -d tmp/results.csv -N http://wls-01.co.spb.ru:3128 http://wls-02.co.spb.ru:3128 http://wls-03.co.spb.ru:3128
Started crawling to tmp/results.csv
{:url=>"ya.ru", :yandex_catalog=>true, :yandex_tic=>"19 000", :yandex_index=>"5", :google_index=>"502 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>3254, :host_age=>"16 лет 9 месяцев 25 дней", :host_ip=>"213.180.193.3", :host_country=>"Russian Federation", :host_from=>"12.07.99", :host_to=>"01.08.16", :download_speed=>"5ms", :external_links=>"1358000"}
{:url=>"vk.com", :yandex_catalog=>true, :yandex_tic=>"360 000", :yandex_index=>"415 493 859", :google_index=>"91 000 000", :google_pagerank=>0, :google_backlinks=>1550, :dmoz_catalog=>true, :alexa_rank=>20, :host_age=>"18 лет 10 месяцев 12 дней", :host_ip=>"87.240.131.117", :host_country=>"Russian Federation", :host_from=>"24.06.97", :host_to=>"23.06.17", :download_speed=>"6ms", :external_links=>"532016067"}
{:url=>"bing.com", :yandex_catalog=>true, :yandex_tic=>"5 800", :yandex_index=>"3 278 304 412", :google_index=>"15 100 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>17, :host_age=>"20 лет 3 месяца 9 дней", :host_ip=>"204.79.197.200", :host_country=>"", :host_from=>"28.01.96", :host_to=>"29.01.19", :download_speed=>"16ms", :external_links=>"5846908"}
{:url=>"tsn.com", :yandex_catalog=>false, :yandex_tic=>"n/a", :yandex_index=>"0", :google_index=>"0", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>false, :alexa_rank=>6887875, :host_age=>"Null", :host_ip=>"65.213.145.195", :host_country=>"", :host_from=>"Null", :host_to=>"Null", :download_speed=>"28ms", :external_links=>"152"}
{:url=>"google.com", :yandex_catalog=>true, :yandex_tic=>"310 000", :yandex_index=>"19 968 655", :google_index=>"2 760 000 000", :google_pagerank=>0, :google_backlinks=>"0", :dmoz_catalog=>true, :alexa_rank=>1, :host_age=>"18 лет 7 месяцев 21 день", :host_ip=>"216.58.212.174", :host_country=>"", :host_from=>"15.09.97", :host_to=>"13.09.20", :download_speed=>"5ms", :external_links=>"215396550"}
```
