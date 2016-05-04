require 'thor'
require 'metrics_crawler/constants'
require 'metrics_crawler/crawler'
require 'metrics_crawler/config'

module MetricsCrawler
  module CLI
    class Start < Thor
      desc 'multi', 'Run crawling for domains in a parallel mode.'
      method_option :config, type: :string, aliases: "-C", desc: "Path to configuration file.", default: MetricsCrawler::DEFAULT_CONF
      method_option :source, type: :string, aliases: "-s", desc: "Path to directory where was stored splitted files.", default: "#{MetricsCrawler::Config.new.settings['domains_path']}"
      method_option :dest, type: :string, aliases: "-d", desc: "Destination for results file.", default: "#{MetricsCrawler::Config.new.settings['results_path']}/#{RESULT_FILE}"
      def multi
        crawler = MetricsCrawler::Crawler.new(options[:config])
        make_header(options[:dest])
        crawler.run(options[:dest])
      end

      desc 'solo', 'Run crawling for domains from file via or without proxy.'
      method_option :config, type: :string, aliases: "-C", desc: "Path to configuration file.", default: MetricsCrawler::DEFAULT_CONF
      method_option :file, type: :string, aliases: "-f", desc: "Domains file."
      method_option :dest, type: :string, aliases: "-d", desc: "Destination for results file.", default: "#{MetricsCrawler::Config.new.settings['results_path']}/#{RESULT_FILE}"
      method_option :proxy, type: :string, aliases: "-p", desc: "Proxyname like 'http://proxyname:port/'", default: nil
      def solo
        crawler = MetricsCrawler::Crawler.new(options[:config])
        make_header(options[:dest])
        crawler.solorun(options[:file], options[:dest], options[:proxy])
      end
    end
  end
end
