require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'PageRankr'
require_relative 'constants'

module MetricsCrawler
  class SeoParams
    YACA_LINK    = 'https://yandex.ru/yaca/?text   ='.freeze
    LINKPAD_LINK = 'https://www.linkpad.ru/?search ='.freeze
    ALEXA_LINK   = 'http ://www.alexa.com/siteinfo'.freeze

    attr_accessor :url, :proxy, :timeout

    def initialize(url, proxy = nil, timeout = 20)
      @proxy    = proxy
      @url      = prepare_url(url)
      @timeout  = timeout.to_i
    end

    def all
      begin
        PageRankr.proxy_service = PageRankr::ProxyServices::Random.new([@proxy]) unless @proxy.nil?
        result = {
          url:              @url,
          google_backlinks: backlinks(@url),
          alexa_rank:       alexa_rank(@url),
          external_links:   external_links(@url),
          download_speed:   benchmarking(@url)
        }
      rescue => ex
        error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      end
      result
    end

    private

    def backlinks(url)
      backlinks = PageRankr.backlinks(url, :google)[:google]
    rescue => ex
      error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      'nil'
    else
      backlinks.nil? ? '0' : backlinks
    end

    def alexa_rank(url)
      doc = Nokogiri::HTML(open("#{ALEXA_LINK}/#{url}", proxy: @proxy, read_timeout: @timeout))
      alexa_rank = doc.css('.metrics-data.align-vmiddle').first.text.strip.delete(',').to_i
      alexa_rank.zero? ? '0' : alexa_rank
    end

    def benchmarking(url)
      dt = `curl -o /dev/null -s -w %{time_total} 'http://#{url}'`
    rescue Net::ReadTimeout => ex
      error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      'Null'
    else
      "#{(dt.tr(',', '.').to_f * 100).ceil}ms"
    end

    def external_links(url)
      external_links = Nokogiri::HTML(open("#{LINKPAD_LINK}#{url}", proxy: @proxy, read_timeout: @timeout))
    rescue SocketError, Errno::ETIMEDOUT => ex
      error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      'Null'
    else
      external_links.css('#a3').text.delete(',')
    end

    def error_handler(error)
      error_log = "#{TMP_PATH}/logs/errors.log"
      FileUtils.mkdir_p(File.dirname(error_log))
      File.open(error_log, 'a') do |f|
        f.puts("#{DateTime.now}: #{error}")
      end
    end

    def prepare_url(url)
      url.gsub!(/(http:\/\/|https:\/\/)/, '')
      url.chomp!('/') if url[-1] == '/'
      URI.parse(URI.encode(url)).to_s
    end
  end
end
