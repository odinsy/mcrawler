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
                host_age
                host_ip
                host_country
                host_from
                host_to
                download_speed
                external_links
                )

    # Exports array with domain hashes to CSV
    # @return [String]  the filename
    def save_to_csv(hash, filename)
      make_dir(File.dirname(filename))
      CSV.open(filename, 'a+', col_sep: '|') do |file|
        file << hash.values.map { |v| v.is_a?(Array) ? v.join(',') : v }
      end
      filename
    end

    # Creates directory tree unless not exists
    def make_dir(dir)
      FileUtils::mkdir_p(dir) unless File.exists?(dir)
    end

    def make_header(filename)
      CSV.open(filename, 'w+', col_sep: '|') do |file|
        file << HEADERS
      end
    end
  end
end
