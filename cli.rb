require './lib/metrics_crawler'
require 'benchmark'

crawler = MetricsCrawler::Crawler.new
# crawler.split
# crawler.run
# crawler.run('data/domain.list', "http://wls-01.co.spb.ru:3128/")
crawler.run_with_proxy

# file = './data/domain.list'
# n = 10000
# Benchmark.bm do |rep|
#   rep.report("readlines") { n.times { File.readlines(file).size } }
#   rep.report("wc -l    ") { n.times { `wc -l #{file}`.to_i } }
#   rep.report("foreach  ") { n.times { File.foreach(file).count } }
# end
