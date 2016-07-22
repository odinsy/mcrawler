require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'PageRankr'
require_relative 'constants'
require_relative 'connection_checker'

module MetricsCrawler
  class SeoParams
    include ConnectionChecker

    YACA_LINK               = 'https://yandex.ru/yaca/?text='.freeze
    PRCY_LINK               = 'http://pr-cy.ru/a'.freeze
    LINKPAD_LINK            = 'https://www.linkpad.ru/?search='.freeze
    ALEXA_LINK              = 'http://www.alexa.com/siteinfo'.freeze
    PRCY_DMOZ_CAT_XPATH     = ".//*[@id='katalogi']/following-sibling::div[1]/div[2]/div[1]/@test-status='success'".freeze
    PRCY_YANDEX_CAT_XPATH   = ".//*[@id='katalogi']/following-sibling::div[1]/div[1]/div[1]/@test-status='success'".freeze
    PRCY_YANDEX_INDEX_XPATH = ".//*[@id='indeksacia']/following-sibling::div[1]/div[1]/div[1]/div[1]/div[2]/a".freeze
    PRCY_GOOGLE_INDEX_XPATH = ".//*[@id='indeksacia']/following-sibling::div[1]/div[2]/div[1]/div[1]/div[2]/a".freeze
    PRCY_YANDEX_TIC_XPATH   = ".//*[@id='osnovnye_parametry']/following-sibling::div[1]/div[1]/div[1]/div[1]/div[2]/a".freeze
    PRCY_HOSTINFO_XPATH     = ".//*[@id='servernaa_informacia']/following-sibling::div[1]".freeze
    # DMOZ_LINK               = 'https://www.dmoz.org/search?q='.freeze

    attr_accessor :url, :proxy, :timeout

    def initialize(url, proxy = nil, timeout = 20)
      @proxy    = proxy
      @url      = prepare_url(url)
      @timeout  = timeout.to_i
    end

    def all
      begin
        PageRankr.proxy_service = PageRankr::ProxyServices::Random.new([@proxy]) unless @proxy.nil?
        doc_prcy  = prcy_info(@url)
        # host_info = host_info(doc_prcy)
        result    = {
          url:              @url,
          yandex_catalog:   yandex_catalog(doc_prcy),
          yandex_tic:       yandex_tic(doc_prcy),
          yandex_index:     yandex_index(doc_prcy),
          google_index:     google_index(doc_prcy),
          google_backlinks: backlinks(@url),
          dmoz_catalog:     dmoz_catalog(doc_prcy),
          alexa_rank:       alexa_rank(@url),
          external_links:   external_links(@url),
          download_speed:   benchmarking(@url),
          # host_age:         host_info[0].force_encoding("utf-8"),
          # host_ip:          host_info[1],
          # host_country:     host_info[3],
          # host_from:        host_info[4],
          # host_to:          host_info[5]
        }
      rescue => ex
        error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      end
      result
    end

    private

    def prcy_info(url)
      Nokogiri::HTML(open("#{PRCY_LINK}/#{url}", :allow_redirections => :safe, proxy: @proxy, read_timeout: @timeout))
    end

    def yandex_catalog(doc_prcy)
      doc_prcy.xpath(PRCY_YANDEX_CAT_XPATH)
    end

    def yandex_tic(doc_prcy)
      doc_prcy.xpath(PRCY_YANDEX_TIC_XPATH).text.strip
    end

    def yandex_index(doc_prcy)
      yandex_index = doc_prcy.xpath(PRCY_YANDEX_INDEX_XPATH).text.strip
      yandex_index.gsub(/n\/a/, '0')
    end

    def google_index(doc_prcy)
      google_index = doc_prcy.xpath(PRCY_GOOGLE_INDEX_XPATH).text.strip
      google_index.gsub(/n\/a/, '0')
    end

    def dmoz_catalog(doc_prcy)
      doc_prcy.xpath(PRCY_YANDEX_CAT_XPATH)
    end

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

    def host_info(doc_prcy)
      result = []
      begin
        registration_info = doc_prcy
      rescue => ex
        error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
        result = %w(Null Null Null Null Null Null)
      else
        registration_info.xpath(PRCY_HOSTINFO_XPATH).each_with_index do |data, i|
          result[i] = data.text.strip.gsub(/(Не определен)а?\./, 'Null')
        end
      end
      result
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
