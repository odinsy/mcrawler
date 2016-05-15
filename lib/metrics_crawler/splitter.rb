require 'fileutils'
require 'yaml'
require "addressable/uri"
require_relative 'config'

module MetricsCrawler
  module Splitter
    # Делит входящий файл с доменами на количество переданных нод, сохраняет файлы с названиями хостов нод в переданную директорию.
    def split(src_file, dst_dir, nodes)
      make_dir(dst_dir)
      nodes       = nodes.map { |node| prepare_node(node) }
      make_domain_files(dst_dir, nodes)
      domains     = File.readlines(src_file)
      part_num    = (domains.count / nodes.count.to_f).ceil
      domains.each_slice(part_num).zip(nodes) do |part, node|
        File.open("#{dst_dir}/#{node}", 'w+') { |f| f.puts part }
        puts "Was created a file with domains for the node #{node}: #{dst_dir}/#{node}"
      end
    end

    private

    # Подготовка имени ноды - берется только hostname.
    def prepare_node(node)
      check_uri(node).host
    end

    # Проверяет URI на корректность.
    # Если URI не содержит hostname или port, выдаст исключение.
    # В противном случае возвращает URI
    def check_uri(uri)
      uri = Addressable::URI.parse(uri)
      raise ArgumentError, "Node #{uri} has a bad URI." if uri.host.nil? || uri.port.nil?
      uri
    end

    # В указанной директории для каждой ноды создается свой файл, если он еще не существует.
    def make_domain_files(dst_dir, nodes)
      nodes.each { |node| FileUtils.touch("#{dst_dir}/#{node}") unless File.exist?("#{dst_dir}/#{node}") }
    end

    # Создает директорию, если она не существует.
    def make_dir(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
  end
end
