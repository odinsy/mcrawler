require './lib/metrics_crawler/seo_params'
require './lib/metrics_crawler/crawler'

crawler = MetricsCrawler::Crawler.new
crawler.split
# crawler.run
# crawler.run_with_proxy
