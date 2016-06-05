require "addressable/uri"

module MetricsCrawler
  module Nodes
    # Подготовка имени ноды - берется только hostname.
    def prepare_nodes(nodes)
      nodes.map { |node| make_uri(node) }
    end
    # Проверяет URI на корректность.
    # Если URI не содержит hostname или port, выдаст исключение.
    # В противном случае возвращает URI
    def make_uri(uri)
      uri = Addressable::URI.parse(uri)
      raise ArgumentError, "Node #{uri} has a bad URI." if uri.host.nil? || uri.port.nil?
      uri
    end
  end
end
