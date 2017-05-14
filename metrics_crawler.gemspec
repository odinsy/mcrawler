# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metrics_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = 'metrics_crawler'
  spec.version       = MetricsCrawler::VERSION
  spec.authors       = ['Oleg Dianov']
  spec.email         = ['odidoit@gmail.com']

  spec.summary       = 'Domain metrics crawler'
  spec.description   = 'Domain metrics crawler description here'
  spec.homepage      = 'https://github.com/odinsy/metrics_crawler'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|data)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['crawler']
  spec.require_paths = ['lib']

  spec.add_dependency 'PageRankr', '~> 4.6'
  spec.add_dependency 'nokogiri', '~> 1.7'
  spec.add_dependency 'parallel', '~> 1.11'
  spec.add_dependency 'ruby-progressbar', '~> 1.8'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'open_uri_redirections', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'factory_girl', '~> 4.8'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.24', '>= 1.24.5'
end
