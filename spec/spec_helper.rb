$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'metrics_crawler'
require 'factory_girl'
require 'webmock/rspec'
require 'vcr'

Dir["./spec/support/*.rb"].each {|f| require f}

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.failure_color = :yellow
end
