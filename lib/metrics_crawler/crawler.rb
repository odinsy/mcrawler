require 'uri'
require 'parallel'
require 'yaml'
require_relative 'config'
require_relative 'constants'
require_relative 'splitter'
require_relative 'connection_checker'
require_relative 'seo_params'
require_relative 'export'

module MetricsCrawler
  class Crawler
    extend Splitter
    include ConnectionChecker
    include Export

    attr_accessor :domains_path, :result_path, :nodes

    def initialize(config_path = nil)
      settings  = Config.new(config_path).settings unless config_path.nil?
      if settings
        @domains_path = settings['domains_path']
        @result_path  = "#{settings['results_path']}/#{RESULT_FILE}"
        @nodes        = settings['nodes']
      end
    end

    def run(src_dir, dest, nodes)
      raise ArgumentError, "In the configuration file does not specify an any proxy server." if nodes.nil?
      Parallel.each(nodes, in_processes: nodes.count) do |node|
        filename = URI.parse(node).host
        solorun("#{src_dir}/#{filename}", dest, node)
      end
    end

    def solorun(src, dest, proxy = nil)
      load_domains(src).each do |domain|
        output = SeoParams.new(domain, proxy).all
        unless output.nil?
          output.delete(:proxy) && save_to_csv(output, dest)
        end
        p output
        sleep 5
      end
    end

    private

    def load_domains(path)
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path).map(&:strip)
    end
  end
end
