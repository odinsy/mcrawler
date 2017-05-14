require 'fileutils'

module MetricsCrawler
  # Module which provides a possibility for save an object to CSV.
  module Export
    HEADERS = %w(url
                 yandex_catalog
                 yandex_tic
                 yandex_index
                 google_index
                 google_pagerank
                 google_backlinks
                 dmoz_catalog
                 alexa_rank
                 external_links
                 download_speed
                 host_age
                 host_ip
                 host_country
                 host_from
                 host_to).freeze

    # Exports array with domain hashes to CSV
    # @return [String]  filename
    # @param [Hash] hash                  Hash of domain metrics
    # @param [String] filename            Path where to save file
    #
    def save_to_csv(hash, filename)
      make_dir(File.dirname(filename))
      CSV.open(filename, 'a+', col_sep: '|') do |file|
        file << hash.values.map { |v| v.is_a?(Array) ? v.join(',') : v }
      end
      filename
    end

    # Creates directory tree if directory doesn't exists
    # @param [String] dir                  Path to directory
    #
    def make_dir(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end

    # Gets HEADERS and creates header in the file
    # @param [String] filename             Path to file where to make header
    #
    def make_header(filename)
      make_dir(File.dirname(filename))
      CSV.open(filename, 'w+', col_sep: '|') do |file|
        file << HEADERS
      end
    end
  end
end
