require 'open-uri'
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
    DMOZ_LINK               = 'https://www.dmoz.org/search?q='.freeze
    ALEXA_LINK              = 'http://www.alexa.com/siteinfo'.freeze
    PRCY_YANDEX_INDEX_XPATH = './/div[@id="box-basik"][1]//div[@class="box-content"]//div[@class="row"]//div[@class="col-sm-4"][1]//div[@class="pull-right"][3]//a'.freeze
    PRCY_YANDEX_CAT_XPATH   = './/div[@id="box-basik"][1]/div[2]/div/div[1]/div[2]/a'.freeze
    PRCY_YANDEX_TIC_XPATH   = './/div[@id="box-basik"][1]/div[2]/div/div[1]/div[1]/a'.freeze
    PRCY_GOOGLE_INDEX_XPATH = './/div[@id="box-basik"][2]//div[@class="box-content"]//div[@class="row"]//div[@class="col-sm-4"][1]//div[@class="pull-right"][3]//a'.freeze
    PRCY_HOSTINFO_XPATH     = './/div[@id="box-basik"][4]//div[@class="box-content"]//div[@class="row"]//div[@class="col-sm-4"]//div[@class="pull-right"]'.freeze

    attr_accessor :url, :proxy

    def initialize(url, proxy = nil)
      @proxy  = URI.parse(URI.encode(proxy)) unless proxy.nil?
      @url    = prepare_url(url)
    end

    def all
      begin
        PageRankr.proxy_service = PageRankr::ProxyServices::Random.new(@proxy.to_s) unless @proxy.nil?
        doc_prcy  = Nokogiri::HTML(open("#{PRCY_LINK}/#{@url}", proxy: @proxy, read_timeout: 20))
        host_info = host_info(doc_prcy)
        result    = {
          url:              @url,
          yandex_catalog:   yandex_catalog(doc_prcy),
          yandex_tic:       yandex_tic(doc_prcy),
          yandex_index:     yandex_index(doc_prcy),
          google_index:     google_index(doc_prcy),
          google_pagerank:  google_pagerank(@url),
          google_backlinks: backlinks(@url),
          dmoz_catalog:     dmoz_catalog(@url),
          alexa_rank:       alexa_rank(@url),
          host_age:         host_info[0].force_encoding("utf-8"),
          host_ip:          host_info[1],
          host_country:     host_info[3],
          host_from:        host_info[4],
          host_to:          host_info[5],
          download_speed:   benchmarking(@url),
          external_links:   external_links(@url)
        }
      rescue RuntimeError => ex
        error_handler("Rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
        exit
      rescue Errno::ECONNREFUSED => ex
        error_handler("Rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
        exit
      rescue => ex
        error_handler("Rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      end
      result
    end

    private

    def yandex_catalog(doc_prcy)
      doc_prcy.xpath(PRCY_YANDEX_CAT_XPATH).text.strip == 'Да' ? true : false
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

    def google_pagerank(url)
      pagerank = PageRankr.ranks(url, :google)[:google]
    rescue => ex
      error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      'nil'
    else
      pagerank.nil? ? '0' : pagerank
    end

    def backlinks(url)
      backlinks = PageRankr.backlinks(url, :google)[:google]
    rescue => ex
      error_handler("Method: #{__callee__}, rescue_class: #{ex.class}, rescue_message: #{ex.message}, domain: #{@url}, proxy: #{@proxy}")
      'nil'
    else
      backlinks.nil? ? '0' : backlinks
    end

    def dmoz_catalog(url)
      doc = Nokogiri::HTML(open("#{DMOZ_LINK}#{url}", proxy: @proxy, read_timeout: 20))
      response_dmoz = doc.css('.open-dir-sites')
      response_dmoz.empty? ? false : true
    end

    def alexa_rank(url)
      doc = Nokogiri::HTML(open("#{ALEXA_LINK}/#{url}", proxy: @proxy, read_timeout: 20))
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
      external_links = Nokogiri::HTML(open("#{LINKPAD_LINK}#{url}", proxy: @proxy, read_timeout: 20))
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
