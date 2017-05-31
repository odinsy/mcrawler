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
      @url        = prepare_url(url)
      @proxy_host = proxy_host.to_s
      @proxy_port = proxy_port.to_i
    end

    def fetch
      uri     = URI.parse("#{API_URL}#{@url}")
      proxy   = Net::HTTP::Proxy(@proxy_host, @proxy_port)
      request = Net::HTTP::Get.new(uri)
      result = proxy.start(uri.host, uri.port) do |http|
        http.request(request).body
      end
      JSON.parse(result)
    end

    private

    def prepare_url(url)
      url.gsub!(/(http:\/\/|https:\/\/)/, '')
      url.chomp!('/') if url[-1] == '/'
      URI.parse(URI.encode(url)).to_s
    end
  end
end
