require 'uri'
require 'pmap'
require './lib/metrics_crawler/splitter'
require './lib/metrics_crawler/connection_checker'
require './lib/metrics_crawler/seo_params'

module MetricsCrawler
  class Crawler
    include Splitter
    include ConnectionChecker

    attr_accessor :nodes

    def initialize
      @nodes  = load_nodes
    end

    def run
      load_domains.each do |domain|
        puts SeoParams.new(domain.strip).all
      end
    end

    def run_with_proxy
      load_domains.each do |domain|
        proxy = @nodes.sample.strip
        # proxy = "http://195.89.201.48:80/"
        # redo unless port_open?(URI.parse(proxy).host, URI.parse(proxy).port)
        redo unless output = SeoParams.new(domain.strip, proxy).all
        sleep 2
      end
    end

    def load_domains(path = 'data/domain.list')
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path)
    end

    def load_nodes(path = 'data/node.list')
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path)
    end

  end
end
