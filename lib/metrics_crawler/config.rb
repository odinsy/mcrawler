require 'yaml'
require 'erb'
require_relative 'constants'
require_relative 'nodes'

module MetricsCrawler
  class Config
    attr_accessor :data
    attr_reader :nodes

    def initialize(filename = CONFIG_PATH)
      @data   = YAML.load_file(filename)
      @nodes  = @data['nodes']
    end

    def self.generate(path = CONFIG_PATH)
      config_dir = File.dirname(path)
      FileUtils.mkdir_p(config_dir) unless File.exist?(config_dir)
      create_config(path) if !File.exist?(path) || overwrite?
    end

    private_class_method

    def self.overwrite?
      print 'Would you like to overwrite the configuration file? [y/n]: '
      case capture_answer
      when 'y', 'yes'
        true
      when 'n', 'no'
        false
      else
        puts 'Invalid input.'
      end
    end

    def self.capture_answer
      $stdin.gets.strip.downcase
    end

    def self.create_config(path)
      default_config = load_with_erb(DEFAULT_CONF)
      File.open(path, 'w+') do |f|
        f.write(default_config.to_yaml)
        puts "Generated configuration file: #{path}"
      end
    end

    def self.load_with_erb(filename)
      YAML.safe_load(ERB.new(File.read(filename)).result)
    end
  end
end
