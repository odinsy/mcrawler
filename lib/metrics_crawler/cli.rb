#!/usr/bin/env ruby
require 'metrics_crawler/crawler'
require 'thor'

module MetricsCrawler
  class CLI < Thor
    desc 'split', 'Split the domains file.'
    method_option :file, type: :string, aliases: "-f", desc: "Domains file", default: "data/domain.list"
    def split
      crawler = MetricsCrawler::Crawler.new
      crawler.split(options[:file])
    end

    desc 'start', 'Run crawling for domains from file via or without proxy.'
    method_option :file, type: :string, aliases: "-f", desc: "Domains file", default: "data/domain.list"
    method_option :proxy, type: :string, aliases: "-p", desc: "Proxyname like 'http://proxyname:port/'", default: nil
    method_option :multi, type: :boolean, desc: "Parallel mode."
    def start
      crawler = MetricsCrawler::Crawler.new
      if options.multi?
        crawler.run_with_proxy
      else
        crawler.run(options[:file], options[:proxy])
      end
    end
  end
end
