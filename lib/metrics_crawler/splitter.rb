require 'fileutils'

module MetricsCrawler
  module Splitter
    def split(filename = './data/domain.list')
      nodes       = @nodes.map { |node| URI.parse(node.strip).host }
      make_domain_files(nodes)
      domains     = File.readlines(filename)
      part_num    = (domains.count / nodes.count.to_f).ceil
      domains.each_slice(part_num).zip(nodes) do |part, node|
        File.open("./data/domains/#{node}", 'w+') { |f| f.puts part }
      end
    end

    private

    def make_domain_files(nodes)
      nodes.each { |node| FileUtils.touch("./data/domains/#{node}") unless File.exists?("./data/domains/#{node}") }
    end
  end
end
