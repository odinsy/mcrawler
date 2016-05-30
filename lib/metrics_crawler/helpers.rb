require 'fileutils'
require "addressable/uri"

module MetricsCrawler
  module Helpers
    # Создает директорию, если она не существует.
    def make_dir(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
    # Подготовка имени ноды - берется только hostname.
    def prepare_nodes(nodes)
      nodes.map { |node| check_uri(node).host }
    end
    # Проверяет URI на корректность.
    # Если URI не содержит hostname или port, выдаст исключение.
    # В противном случае возвращает URI
    def check_uri(uri)
      uri = Addressable::URI.parse(uri)
      raise ArgumentError, "Node #{uri} has a bad URI." if uri.host.nil? || uri.port.nil?
      uri
    end
  end
end
