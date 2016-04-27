#!/usr/bin/env ruby

module MetricsCrawler
  # Module which provides a possibility for save an object to JSON or CSV.
  module Export
    # Exports array with movie hashes to JSON
    # @return [String]  the filename
    def save_to_json(hash, filename = './tmp/domains.json')
      File.open(filename, 'a+') { |f| f.puts hash.to_json }
      filename
    end

    # Exports array with movie hashes to CSV
    # @return [String]  the filename
    def save_to_csv(hash, filename = './tmp/domains.csv')
      CSV.open(filename, 'a+', col_sep: '|') do |file|
        file << hash.values.map { |v| v.is_a?(Array) ? v.join(',') : v }
      end
      filename
    end
  end
end
