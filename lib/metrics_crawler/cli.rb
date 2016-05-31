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
      MetricsCrawler::Config.new
    end

    desc 'start', 'Start crawling metrics for domains'
    method_option :config,
                  type: :string,
                  aliases: "-C",
                  desc: "Path to configuration file. Default: #{MetricsCrawler::CONFIG_PATH}",
                  lazy_default: MetricsCrawler::CONFIG_PATH
    method_option :file,
                  type: :string,
                  aliases: "-f",
                  desc: "Domains file.",
                  required: true
    method_option :dest,
                  type: :string,
                  aliases: "-d",
                  desc: "Destination for results file.",
                  required: true
    method_option :nodes,
                  type: :array,
                  aliases: "-P",
                  desc: "Proxies list. Example: -P http://node01.org:3128 http://node02.org:3128",
                  default: nil
    def start
      if options.config?
        crawler = MetricsCrawler::Crawler.new(options[:config])
        say "Started crawling #{options[:file]} to #{options[:dest]}"
        crawler.run(options[:file], options[:dest], crawler.nodes)
      else
        crawler = MetricsCrawler::Crawler.new
        say "Started crawling #{options[:file]} to #{options[:dest]}"
        crawler.run(options[:file], options[:dest], options[:nodes])
      end
    end
  end
end
