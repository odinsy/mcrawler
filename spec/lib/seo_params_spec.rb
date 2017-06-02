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
      subject(:result) { seo_params.all }

      it 'responds to method "all"' do
        expect(seo_params).to respond_to(:all)
      end
      it 'returns a Hash' do
        expect(result).to be_a(Hash)
      end
    end
  end

  context 'with proxy' do
    describe '.new' do
      it 'creates new instance' do
        expect(MetricsCrawler::SeoParams.new(url, proxy)).to be_a(MetricsCrawler::SeoParams)
      end
      it 'have a class String for the attribute PROXY' do
        expect(seo_params_with_proxy.proxy).to be_a(String)
      end
    end
  end
end
