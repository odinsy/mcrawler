#!/usr/bin/env ruby
require 'metrics_crawler/crawler'
require 'thor'

module MetricsCrawler
  class CLI < Thor
    include Export

    desc 'split', 'Split the domains file.'
    method_option :file, type: :string, aliases: "-f", desc: "Domains file", default: "data/domain.list"
    def split
      crawler = MetricsCrawler::Crawler.new
      crawler.split(options[:file])
    end

    desc 'start', 'Run crawling for domains from file via or without proxy.'
    method_option :file, type: :string, aliases: "-f", desc: "Domains file", default: "data/domain.list"
    method_option :dest, type: :string, aliases: "-d", desc: "Destination for results file", default: "data/results/domains.csv"
    method_option :proxy, type: :string, aliases: "-p", desc: "Proxyname like 'http://proxyname:port/'", default: nil
    method_option :multi, type: :boolean, desc: "Parallel mode."
    def start
      crawler = MetricsCrawler::Crawler.new
      make_header(options[:dest])
      if options.multi?
        crawler.run_with_proxy(options[:dest])
      else
        crawler.run(options[:file], options[:dest], options[:proxy])
      end
    end
  end
end
