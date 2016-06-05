require 'thor'
require_relative 'crawler'
require_relative 'constants'
require_relative 'config'
require_relative 'version'

module MetricsCrawler
  # CLI Module
  class CLI < Thor
    desc 'version', 'Show version'
    def version
      say "MetricsCrawler #{MetricsCrawler::VERSION}"
    end

    desc 'init', 'Generate all the necessary files'
    def init
      MetricsCrawler::Config.generate
    end

    desc 'start', 'Start crawling metrics for domains'
    method_option :config,
                  type: :string,
                  aliases: '-C',
                  desc: "Path to the configuration file. Default: #{MetricsCrawler::CONFIG_PATH}",
                  lazy_default: MetricsCrawler::CONFIG_PATH
    method_option :file,
                  type: :string,
                  aliases: '-f',
                  desc: 'Domains file.',
                  required: true
    method_option :dest,
                  type: :string,
                  aliases: '-d',
                  desc: 'Destination for the results file.',
                  required: true
    method_option :nodes,
                  type: :array,
                  aliases: '-P',
                  desc: 'Proxies list. Example: -P http://node01.org:3128 http://node02.org:3128',
                  default: nil
    def start
      config  = Config.new(options[:config]) if options.config?
      nodes   = options.config? ? config.nodes : options[:nodes]
      crawler = MetricsCrawler::Crawler.new(nodes)
      crawler.run(options[:file], options[:dest])
    end
  end
end
