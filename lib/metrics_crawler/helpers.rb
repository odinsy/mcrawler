require 'fileutils'
require 'addressable/uri'

module MetricsCrawler
  # Module which accumulates helper methods
  module Helpers
    # Creates directory if it doesn't exist
    # @param [String] dir       Path to the directory, which you want to create
    def make_dir(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
  end
end
