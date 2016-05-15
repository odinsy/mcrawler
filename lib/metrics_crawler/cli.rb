require 'thor'
require_relative 'crawler'
require_relative 'constants'
require_relative 'config'
require_relative 'cli/start'

module MetricsCrawler
  class CLI < Thor
    desc 'start TYPE', 'Start crawling. Type can be SOLO or MULTI.'
    subcommand 'start', MetricsCrawler::Start

    desc 'init', 'Generate all the necessary files'
    def init
      MetricsCrawler::Config.new
    end

    desc 'split', 'Split the domains file.'
    method_option :config, type: :string, aliases: "-C", desc: "Path to configuration file. Default: #{MetricsCrawler::CONFIG_PATH}", lazy_default: MetricsCrawler::CONFIG_PATH
    method_option :file, type: :string, aliases: "-f", desc: "Domains file.", required: true
    method_option :dest, type: :string, aliases: "-d", desc: "Path to directory where to store splitted files."
    method_option :nodes, type: :array, aliases: "-n", desc: "Path to configuration file where declared nodes."
    def split
      if options.config?
        config = MetricsCrawler::Config.new(options[:config]).settings
        MetricsCrawler::Crawler.split_to_files(options[:file], config['domains_path'], config['nodes'])
      elsif options.file? && options.dest? && options.nodes?
        MetricsCrawler::Crawler.split_to_files(options[:file], options[:dest], options[:nodes])
      else
        say "Were not passed all arguments."
      end
    end
  end
end
