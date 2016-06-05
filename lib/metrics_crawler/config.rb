require 'yaml'
require 'erb'
require_relative 'constants'
require_relative 'nodes'

module MetricsCrawler
  class Config
    include Nodes

    attr_accessor :data

    def initialize(filename = CONFIG_PATH)
      @data = YAML.load_file(filename)
    end

    def nodes
      @nodes = prepare_nodes(data['nodes'])
    end

    def self.generate(path = CONFIG_PATH)
      FileUtils.mkdir_p(File.dirname(path))
      config = load_with_erb(DEFAULT_CONF)
      File.open(path, 'w+') do |f|
        f.write(config.to_yaml)
        puts "Generated configuration file: #{path}"
      end
    end

    private

    def self.load_with_erb(filename)
      YAML.load(ERB.new(File.read(filename)).result)
    end
  end
end
