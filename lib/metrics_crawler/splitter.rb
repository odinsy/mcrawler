#!/usr/bin/env ruby

require 'fileutils'

module MetricsCrawler
  module Splitter
    def split(filename = './data/domain.list')
      make_domain_files(nodes)
      nodes       = @nodes.map { |node| URI.parse(node.strip).host }
      domains_num = %x{wc -l #{filename}}.split[0].to_i
      part_num    = (domains_num / nodes.count.to_f).ceil
      node_index  = 0
      File.readlines(filename).each_slice(part_num) do |part|
        File.open("./data/domains/#{nodes[node_index]}", 'w+') { |f| f.puts part }
        node_index += 1
      end
    end

    def make_domain_files(nodes)
      nodes.each { |node| FileUtils.touch("./data/domains/#{node}") unless File.exists?("./data/domains/#{node}") }
    end
  end
end
