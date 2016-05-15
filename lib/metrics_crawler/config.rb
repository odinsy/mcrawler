require 'yaml'
require 'erb'
require_relative 'constants'

module MetricsCrawler
  class Config
    attr_accessor :settings

    def initialize(filename = CONFIG_PATH)
      Config.generate(filename) unless File.exist?(filename)
      @settings = YAML.load_file(filename)
    end

    def self.load(filename)
      YAML.load(ERB.new(File.read(filename)).result)
    end

    def self.generate(path)
      FileUtils.mkdir_p(File.dirname(path))
      config = load(DEFAULT_CONF)
      File.open(path, 'w+') do |f|
        f.write(config.to_yaml)
        puts "Generated configuration file: #{path}"
      end
    end
  end
end
