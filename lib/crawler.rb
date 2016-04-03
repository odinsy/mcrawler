require 'socket'
require 'timeout'
require 'uri'
require './lib/seo_params.rb'

class Crawler
  attr_accessor :nodes

  def initialize
    @nodes  = load_nodes
  end

  def run!
    load_domains.each do |domain|
      proxy = @nodes.sample.strip
      p proxy
      # redo if !port_open?(proxy.host, proxy.port)
      puts SeoParams.new(domain.strip, proxy).all
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


  def port_open?(ip, port, seconds = 1)
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
