module MetricsCrawler
  # MetricsCrawler::Prcy class
  # @example
  #   MetricsCrawler::Prcy.new("google.com")
  #
  class Prcy
    API_LINK = 'http://api.pr-cy.ru/analysis.json?domain='.freeze

    def initialize(url, proxy = nil, timeout = 20)
      @url      = prepare_url(url)
      @proxy    = proxy
      @timeout  = timeout.to_i
    end

    def get_metrics
    end

    private

    def prepare_url(url)
      url.gsub!(/(http:\/\/|https:\/\/)/, '')
      url.chomp!('/') if url[-1] == '/'
      URI.parse(URI.encode(url)).to_s
    end
  end
end
