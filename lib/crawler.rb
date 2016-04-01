require File.expand_path('../seo_params.rb', __FILE__)

class Crawler
  attr_accessor :domains, :nodes

  def initialize
    @domains  = load_domains
    @nodes    = load_nodes
  end

  def run!
    @domains.each_slice(@nodes.count) do |array|
      @nodes.each do |node|
        array.each do |url|
          p SeoParams.new(url.strip, node.strip).all
        end
      end
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
end
