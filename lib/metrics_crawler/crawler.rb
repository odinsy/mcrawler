require 'uri'
require 'parallel'
require_relative 'splitter'
require_relative 'connection_checker'
require_relative 'seo_params'
require_relative 'export'

module MetricsCrawler
  class Crawler
    include Splitter
    include ConnectionChecker
    include Export

    attr_accessor :nodes

    def initialize
      @nodes = load_nodes
    end

    def run_with_proxy
      Parallel.each(@nodes, in_processes: @nodes.count) do |node|
        filename = URI.parse(node).host
        run("data/domains/#{filename}", node)
      end
    end

    def run(path = 'data/domain.list', proxy = nil)
      load_domains(path).each do |domain|
        output = SeoParams.new(domain, proxy).all
        p output
        output.delete(:proxy) && save_to_csv(output) unless output.nil?
        sleep 5
      end
    end

    private

    def load_domains(path)
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path).map { |domain| domain.strip }
    end

    def load_nodes(path = 'data/node.list')
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path).map { |node| node.strip }
    end
  end
end
