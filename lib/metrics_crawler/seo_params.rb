require 'open-uri'
require 'nokogiri'
require 'PageRankr'

module MetricsCrawler
  class SeoParams
    def initialize(url, proxy = nil)
      @proxy  = URI.parse(URI.encode(proxy)) unless proxy.nil?
      @url    = url.gsub(/(http:\/\/|https:\/\/)/, '')
      if @url[-1] == '/'
        @url.chomp!('/')
      end
    end

    def all
      begin
        doc_prcy  = Nokogiri::HTML(open("http://pr-cy.ru/a/#{@url}", proxy: @proxy, read_timeout: 10))
        yandex    = Nokogiri::HTML(open("https://yaca.yandex.ru/yca?text=#{@url}&yaca=1", proxy: @proxy, read_timeout: 10))
        host_info = get_host_info(doc_prcy)
        result    = {
          url:              @url,
          tic:              get_yandex_tic(yandex),
          yandex_index:     get_yandex_index(doc_prcy),
          yandex_catalog:   get_yandex_catalog(yandex),
          goggle_pagerank:  get_google_pagerank(@url),
          google_index:     get_google_index(doc_prcy),
          backlinks:        get_backlinks(@url),
          dmoz_catalog:     get_dmoz_catalog(@url),
          alexa_rank:       get_alexa_rank(@url),
          host_age:         host_info[0],
          host_ip:          host_info[1],
          host_country:     host_info[3],
          host_from:        host_info[4],
          host_to:          host_info[5],
          download_speed:   get_benchmarking(@url),
          external_links:   get_external_links(@url)
        }
      rescue => ex
        error_handler("#{DateTime.now} #{ex.class} #{ex.message}")
        # return ex.inspect
        # return ex.backtrace
        # exit
      end
      result
    end

    private

    def get_yandex_catalog(doc)
      response_sites = doc.css(".b-result__quote")
      if response_sites.count > 0
        true
      else
        false
      end
    end

    def get_yandex_tic(doc)
      response_sites = doc.css(".b-result__quote")
      if response_sites.count > 0
        response_sites.first.text.gsub(/Цитируемость: /, '')
      else
        'Null'
      end
    end

    def get_yandex_index(doc_prcy)
      yandex_index = doc_prcy.xpath('//div[@class="container main-content"]//div[@id="analysisContent"]//div[@class="row"]//div[@class="col-sm-12 col-md-9 col-xs-12"]//div[@id="box-basik"][1]//div[@class="box-content"]//div[@class="row"]//div[@class="col-sm-4"][1]//div[@class="pull-right"][3]//a').text.strip
      yandex_index.gsub(/n\/a/, 'Null')
    end

    def get_google_index(doc_prcy)
      google_index = doc_prcy.xpath('//div[@class="container main-content"]//div[@id="analysisContent"]//div[@class="row"]//div[@class="col-sm-12 col-md-9 col-xs-12"]//div[@id="box-basik"][2]//div[@class="box-content"]//div[@class="row"]//div[@class="col-sm-4"][1]//div[@class="pull-right"][3]//a').text.strip
      google_index.gsub(/n\/a/, 'Null')
    end

    def get_google_pagerank(url)
      PageRankr.proxy_service = PageRankr::ProxyServices::Random.new(@proxy.to_s) unless @proxy.nil?
      pagerank = PageRankr.ranks(url, :google)[:google]
      if pagerank.nil?
        'Null'
      else
        pagerank
      end
    end

    def get_backlinks(url)
      begin
        PageRankr.proxy_service = PageRankr::ProxyServices::Random.new(@proxy.to_s) unless @proxy.nil?
        backlinks = PageRankr.backlinks(url, :google)[:google]
      rescue SocketError
        error_handler ("SocketError: не получилось узнать количество backlinks для #{url}")
        'Null'
      else
        backlinks = 'Null' if backlinks.nil?
        backlinks
      end
    end

    def get_dmoz_catalog(url)
      doc = Nokogiri::HTML(open("https://www.dmoz.org/search?q=#{url}", proxy: @proxy, read_timeout: 10))
      response_dmoz = doc.css(".open-dir-sites")
      response_dmoz.empty? ? false : true
    end


    def get_alexa_rank(url)
      doc = Nokogiri::HTML(open("http://www.alexa.com/siteinfo/#{url}", proxy: @proxy, read_timeout: 10))
      alexa_rank = doc.css(".metrics-data.align-vmiddle").first.text.strip.gsub(',', '').to_i
      if alexa_rank.zero?
        'Null'
      else
        alexa_rank
      end
    end

    def get_host_info(doc_prcy)
      result = []
      begin
        registration_info = doc_prcy
      rescue => ex
        error_handler("#{DateTime.now} #{ex.class} #{ex.message}")
        result = ['Null', 'Null', 'Null', 'Null', 'Null', 'Null']
      else
        registration_info.xpath('//div[@class="container main-content"]//div[@id="analysisContent"]//div[@class="row"]//div[@class="col-sm-12 col-md-9 col-xs-12"]//div[@id="box-basik"][4]//div[@class="box-content"]//div[@class="row"]//div[@class="col-sm-4"]//div[@class="pull-right"]').each_with_index do |data, i|
          result[i] = data.text.strip.gsub(/(Не определен)а?\./, 'Null')
        end
      end
      result
    end

    def get_benchmarking(url)
      begin
        dt = `curl -o /dev/null -s -w %{time_total} 'http://#{url}'`
      rescue Net::ReadTimeout => ex
        error_handler("#{DateTime.now} #{ex.class} #{ex.message}")
        'Null'
      else
        "#{(dt.gsub(',','.').to_f*100).ceil}ms"
      end
    end

    def get_external_links(url)
      begin
        external_links = Nokogiri::HTML(open("https://www.linkpad.ru/?search=#{url}", proxy: @proxy, read_timeout: 10))
      rescue SocketError, Errno::ETIMEDOUT => ex
        error_handler("#{DateTime.now} #{ex.class} #{ex.message}")
        'Null'
      else
        external_links.css('#a3').text.gsub(',', '')
      end
    end

    def error_handler(error)
      File.open('errors', 'a') do |f|
        f.puts("#{DateTime.now}: #{error}")
      end
    end
  end
end
