# README #

Скрипт для получения seo информации о домене.

### Инструкция по установке ###

* В консоли перейти в директорию, содержащую файлы скрипта
* gem install bundler - установить гем для отслеживания зависимостей в проекте
* bundle install - произойдет установка нужных гемов
* запускать скрипт с помощью команды

```
#!bash

ruby script.rb [OPTIONS]
```

### Возможные оцпии(OPTIONS) ###


```
#!bash

ruby script.rb --help
Usage: script [options]
    -i, --input_file FILE_PATH       Input file
    -o, --output_file FILE_PATH      Output file
    -n, --host_names "HOSTS"         Array with hosts names

```

* при указании опции -i /path/to/file — иформация будет построчно читаться с файла.
* -n 'list of hosts' - список хостов передается вручную, разделитель пробел
* -o /path/to/file/ - вся полученная информация о хостинге будет сохранена в файл( если этот option не указан, то информация будет выведна в терминал )