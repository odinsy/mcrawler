require 'thor'
require_relative 'crawler'
require_relative 'constants'
require_relative 'config'
require_relative 'cli/start'

module MetricsCrawler
  class CLI < Thor
    # desc 'start TYPE', 'Start crawling. Type can be SOLO or MULTI.'
    # subcommand 'start', MetricsCrawler::Start

    desc 'init', 'Generate all the necessary files'
    def init
      MetricsCrawler::Config.new
    end

    desc 'start', 'Start crawling metrics for domains in a parallel mode.'
    method_option :config, type: :string, aliases: "-C", desc: "Path to configuration file. Default: #{MetricsCrawler::CONFIG_PATH}", lazy_default: MetricsCrawler::CONFIG_PATH
    method_option :file, type: :string, aliases: "-f", desc: "Domains file.", required: true
    method_option :dest, type: :string, aliases: "-d", desc: "Destination for results file."
    method_option :nodes, type: :array, aliases: "-P", desc: "Proxies list.", default: nil
    def start
      if options.config?
        crawler = MetricsCrawler::Crawler.new(options[:config])
        say "Started crawling to #{crawler.result_path}"
        crawler.run(crawler.domains_path, crawler.result_path, crawler.nodes)
      elsif options.file? && options.dest?
        crawler = MetricsCrawler::Crawler.new
        say "Started crawling to #{options[:dest]}"
        crawler.run(options[:file], options[:dest], options[:nodes])
      else
        say "Were not passed all arguments."
      end
    end
  end
end
