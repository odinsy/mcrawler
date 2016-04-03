require File.expand_path('../lib/seo_params.rb', __FILE__)
require File.expand_path('../lib/crawler.rb', __FILE__)

crawler = Crawler.new
crawler.run!
