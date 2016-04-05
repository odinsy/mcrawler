require 'socket'
require 'timeout'
require 'uri'
require 'pmap'
require './lib/seo_params.rb'

class Crawler
  attr_accessor :nodes

  def initialize
    @nodes  = load_nodes
  end

  def run
    count = 0
    load_domains.each do |domain|
      count += 1
      puts SeoParams.new(domain.strip).all
      puts count
    end
  end

  def run_with_proxy
    count = 0
    load_domains.each do |domain|
      proxy = @nodes.sample.strip
      # proxy = "http://195.89.201.48:80/"
      # redo unless port_open?(URI.parse(proxy).host, URI.parse(proxy).port)
      redo unless output = SeoParams.new(domain.strip, proxy).all
      count += 1
      puts proxy
      puts output
      puts count
      sleep 2
    end
  end

  def load_domains(path = 'data/domain.list')
    raise ArgumentError, "File #{path} not found." unless File.exist?(path)
    File.readlines(path)
  end

  def load_nodes(path = 'data/node.list')
    raise ArgumentError, "File #{path} not found." unless File.exist?(path)
    File.readlines(path)
  end

  def port_open?(ip, port, seconds = 2)
    Timeout::timeout(seconds) do
      begin
        TCPSocket.new(ip, port).close
        true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        false
      end
    end
  rescue Timeout::Error
    false
  end

end
