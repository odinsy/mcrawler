require './lib/metrics_crawler'

crawler = MetricsCrawler::Crawler.new
crawler.split
crawler.run
# crawler.run_with_proxy
