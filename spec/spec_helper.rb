$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'metrics_crawler'
require 'factory_girl'

Dir["./spec/support/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.failure_color = :yellow
end
