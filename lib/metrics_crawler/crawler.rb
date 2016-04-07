require 'uri'
require 'pmap'
require_relative 'splitter'
require_relative 'connection_checker'
require_relative 'seo_params'
require_relative 'export'

module MetricsCrawler
  class Crawler
    include Splitter
    include ConnectionChecker
    include Export

    attr_accessor :nodes, :results

    def initialize
      @results  = []
      @nodes    = load_nodes
    end

    def run_with_proxy
      @nodes.peach(nodes.count) do |node|
        domains = URI.parse(node).host
        run("data/domains/#{domains}", node)
      end
    end

    def run(path = 'data/domain.list', proxy = nil)
      load_domains(path).each do |domain|
        output = SeoParams.new(domain.strip, proxy).all
        save_to_csv(output) unless output.nil?
        p output
        sleep 10
      end
    end

    private

    def load_domains(path)
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path)
    end

    def load_nodes(path = 'data/node.list')
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path).map { |node| node.strip }
    end
  end
end
