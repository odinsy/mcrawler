require 'fileutils'
require 'yaml'
require "addressable/uri"
require_relative 'helpers'

module MetricsCrawler
  module Splitter
    include Helpers
    # Делит входящий файл с доменами на количество переданных нод
    # Возвращает хэш вида {node1: [domain1, domain2], node2: [domain4, domain5], ..}
    def split(file, nodes)
      domains   = load_domains(file)
      part_num  = (domains.count / nodes.count.to_f).ceil
      domains   = domains.each_slice(part_num)
      nodes.zip(domains).map { |k, v| [k.to_sym, v] }.to_h
    end
  end
end
