require 'parallel'
require 'uri'
require 'yaml'
require 'fileutils'
require_relative 'config'
require_relative 'nodes'
require_relative 'seo_params'
require_relative 'constants'
require_relative 'export'

module MetricsCrawler
  # Class which provides a possibility for crawling metrics of domains
  # @example
  #   crawler = MetricsCrawler::Crawler.new(["http://node01.example.com", "http://node02.example.com"])
  #   crawler = MetricsCrawler::Crawler.new
  class Crawler
    include Export

    attr_accessor :nodes
    # Creates a new MetricsCrawler::Crawler object
    # @param [Array] nodes                  Input array of nodes
    # @attr [MetricsCrawler::Nodes] nodes   Array of the nodes
    #
    def initialize(nodes = nil)
      @nodes = MetricsCrawler::Nodes.new(nodes)
    end

    # Runs the crawler
    # @param [String] file                Path to the file with domains
    # @param [String] destination         Path to the results file
    # @param [Array]  nodes               Array of the nodes
    #
    def run(file, destination, nodes = @nodes)
      domains = nodes.nil? ? load_domains(file) : split(file, nodes)
      make_header(destination)
      if nodes.nil?
        fetch(domains, destination)
      else
        Parallel.each(nodes, in_processes: nodes.count) { |node| fetch(domains[node], destination, node) }
      end
    end

    # Splits the input file with domains into count of nodes.
    # @return [Hash]                        Hash like "http://node01.example.com": ["domain1", "domain2"], "http://node02.example.com": ["domain4", "domain5"]
    # @param [String] file                  Path to the file with domains
    # @param [Array]  nodes                 Array of the nodes
    #
    def split(file, nodes)
      domains   = load_domains(file)
      part_num  = (domains.count / nodes.count.to_f).ceil
      domains   = domains.each_slice(part_num)
      nodes.zip(domains).to_h
      # nodes.zip(domains).map { |k, v| [k.to_sym, v] }.to_h
    end

    private

    # Fetches results for array of domains via or without proxy and saves to the file.
    # @param [Array] domains                Array of the domains
    # @param [String] destination           Path to the results file
    # @param [String] proxy                 Proxy-server like "http://node01.example.com"
    #
    def fetch(domains, destination, proxy = nil)
      domains.each do |domain|
        output = SeoParams.new(domain, proxy).all
        puts "#{proxy}=> #{output}"
        save_to_csv(output, destination) unless output.nil?
        sleep 5
      end
    end

    # Loads domains from file, line by line.
    # 1 domain = 1 line
    # @return [Array]                       Array of the domains
    # @param [String] path                  Path to the file with domains
    #
    def load_domains(path)
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path).map(&:strip)
    end
  end
end
