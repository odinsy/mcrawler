require 'thor'
require 'metrics_crawler/constants'
require 'metrics_crawler/crawler'
require 'metrics_crawler/config'
require 'metrics_crawler/export'

module MetricsCrawler
  class Start < Thor
    include Export

    desc 'solo', 'Start crawling metrics for domains from file via or without proxy.'
    method_option :file, type: :string, aliases: "-f", desc: "Domains file.", required: true
    method_option :dest, type: :string, aliases: "-d", desc: "Destination for results file.", required: true
    method_option :proxy, type: :string, aliases: "-p", desc: "Proxyname like 'http://proxyname:port/'", default: nil
    def solo
      crawler = MetricsCrawler::Crawler.new
      say "Started crawling to #{options[:dest]}"
      make_header(options[:dest])
      crawler.solorun(options[:file], options[:dest], options[:proxy])
    end

    desc 'multi', 'Start crawling metrics for domains in a parallel mode.'
    method_option :config, type: :string, aliases: "-C", desc: "Path to configuration file. Default: #{MetricsCrawler::CONFIG_PATH}", lazy_default: MetricsCrawler::CONFIG_PATH
    method_option :source, type: :string, aliases: "-s", desc: "Path to directory where was stored splitted files."
    method_option :dest, type: :string, aliases: "-d", desc: "Destination for results file."
    method_option :nodes, type: :array, aliases: "-N", desc: "List of nodes."
    def multi
      if options.config?
        crawler = MetricsCrawler::Crawler.new(options[:config])
        say "Started crawling to #{crawler.result_path}"
        make_header(crawler.result_path)
        crawler.run(crawler.domains_path, crawler.result_path, crawler.nodes)
      elsif options.source? && options.dest? && options.nodes?
        crawler = MetricsCrawler::Crawler.new
        say "Started crawling to #{options[:dest]}"
        make_header(options[:dest])
        crawler.run(options[:source], options[:dest], options[:nodes])
      else
        say "Were not passed all arguments."
      end
    end
  end
end
