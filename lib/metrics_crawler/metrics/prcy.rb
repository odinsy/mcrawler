require 'net/http'
require 'json'

module MetricsCrawler
  # MetricsCrawler::Prcy class
  # @example
  #   MetricsCrawler::Prcy.new("google.com")
  #
  class Prcy
    API_URL = 'http://api.pr-cy.ru/analysis.json?domain='.freeze

    def initialize(url, proxy_host = nil, proxy_port = nil)
      @url = prepare_url(url)
      @proxy_host = proxy_host
      @proxy_port = proxy_port
    end

    def fetch
      uri = URI("#{API_URL}#{@url}")
      Net::HTTP.new(uri, nil, @proxy_host, @proxy_port).start do |http|
        res = http.get(uri)
        JSON.parse(res)
      end
    end

    private

    def prepare_url(url)
      url.gsub!(/(http:\/\/|https:\/\/)/, '')
      url.chomp!('/') if url[-1] == '/'
      URI.parse(URI.encode(url)).to_s
    end
  end
end
