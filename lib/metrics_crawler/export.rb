require 'fileutils'

module MetricsCrawler
  # Module which provides a possibility for save an object to JSON or CSV.
  module Export
    # Exports array with movie hashes to JSON
    # @return [String]  the filename
    def save_to_json(hash, filename = './data/results/domains.json')
      make_dir('./data/results')
      File.open(filename, 'a+') { |f| f.puts hash.to_json }
      filename
    end

    # Exports array with movie hashes to CSV
    # @return [String]  the filename
    def save_to_csv(hash, filename = './data/results/domains.csv')
      make_dir('./data/results')
      CSV.open(filename, 'a+', col_sep: '|') do |file|
        file << hash.values.map { |v| v.is_a?(Array) ? v.join(',') : v }
      end
      filename
    end

    # Creates directory tree unless not exists
    def make_dir(dir)
      FileUtils::mkdir_p(dir) unless File.exists?(dir)
    end
  end
end
