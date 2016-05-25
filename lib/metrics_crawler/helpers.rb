module MetricsCrawler
  module Helpers
    # Создает директорию, если она не существует.
    def make_dir(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
    
    def load_domains(path)
      raise ArgumentError, "File #{path} not found." unless File.exist?(path)
      File.readlines(path).map(&:strip)
    end
  end
end
