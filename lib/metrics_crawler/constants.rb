require_relative 'application'

module MetricsCrawler
  APPLICATION   = "metrics_crawler".freeze
  TMP_PATH      = "/tmp/#{APPLICATION}".freeze
  DEFAULT_CONF  = "#{root}/config/config.yml".freeze
  CONFIG_PATH   = ENV['HOME'] + "/.config/#{APPLICATION}/config.yml".freeze
  TIMESTAMP     = `date +%Y%m%d%H%M`.to_s.strip.freeze
  RESULT_FILE   = "#{TIMESTAMP}-res.csv".freeze
end
