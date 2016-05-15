require 'metrics_crawler/seo_params'

describe 'SeoParams' do
  let(:seo_params) { build(:seo_params) }
  let(:seo_params_with_proxy) { build(:seo_params_with_proxy) }
  let(:url) { 'http://google.com' }
  let(:proxy) { 'http://wls-01.co.spb.ru:3128' }

  context 'without proxy' do
    describe '.new' do
      it 'creates new instance' do
        expect(MetricsCrawler::SeoParams.new(url)).to be_a(MetricsCrawler::SeoParams)
      end
      it 'makes an URL shorter' do
        expect(seo_params.url).to eq('www.facebook.com')
      end
    end

    describe '.all', vcr: true do
      attributes = %w(url yandex_catalog yandex_tic yandex_index google_index google_pagerank google_backlinks dmoz_catalog alexa_rank host_age host_ip host_country host_from host_to download_speed external_links)
      subject(:result) { seo_params.all }

      it 'responds to method "all"' do
        expect(seo_params).to respond_to(:all)
      end
      it 'returns a Hash' do
        expect(result).to be_a(Hash)
      end
      attributes.each do |key|
        it "returns result with a key #{key}" do
          expect(result).to have_key(key.to_sym)
        end
      end
    end
  end

  context 'with proxy' do
    describe '.new' do
      it 'creates new instance' do
        expect(MetricsCrawler::SeoParams.new(url, proxy)).to be_a(MetricsCrawler::SeoParams)
      end
      it 'have a class URI::HTTP for the attribute PROXY' do
        expect(seo_params_with_proxy.proxy).to be_a(URI::HTTP)
      end
    end
  end
end
