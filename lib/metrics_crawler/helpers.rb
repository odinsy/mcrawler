require 'fileutils'
require "addressable/uri"

module MetricsCrawler
  module Helpers
    # Создает директорию, если она не существует.
    def make_dir(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
  end
end
