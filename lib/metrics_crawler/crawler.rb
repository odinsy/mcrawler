require 'uri'
require 'parallel'
require 'yaml'
require_relative 'config'
require_relative 'seo_params'
require_relative 'constants'
require_relative 'splitter'
require_relative 'export'
require_relative 'helpers'

module MetricsCrawler
  class Crawler
    include Splitter
    include Export
    include Helpers

    attr_accessor :domains_path, :result_path, :nodes

    def initialize(config_path = nil)
      settings  = Config.new(config_path).settings unless config_path.nil?
      if settings
        @domains_path = settings['domains_path']
        @result_path  = "#{settings['results_path']}/#{RESULT_FILE}"
        @nodes        = settings['nodes']
      end
    end

    def run(file, destination, nodes = nil)
      domains = nodes.nil? ? load_domains(file) : split(file, nodes)
      make_header(destination)
      if nodes.nil?
        fetch(domains, destination, nodes)
      else
        Parallel.each(nodes, in_processes: nodes.count) do |node|
          fetch(domains[node], destination, node)
        end
      end
    end

    private
    # Сбор результатов для массива доменов
    def fetch(domains, destination, proxy)
      domains.each do |domain|
        output = SeoParams.new(domain, proxy).all
        save_to_csv(output, destination) unless output.nil?
        sleep 5
      end
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
