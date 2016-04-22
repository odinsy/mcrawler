require 'metrics_crawler/seo_params'

describe "SeoParams" do
  let(:seo_params) { build(:seo_params) }
  let(:url) { 'https://www.facebook.com/' }
  let(:proxy) { 'http://wls-01.co.spb.ru:3128' }

  context 'without proxy' do
    describe ".new" do
      it 'creates new instance' do
        expect(MetricsCrawler::SeoParams.new(url)).to be_a(MetricsCrawler::SeoParams)
      end
    end
    describe 'all' do
      it 'returns a Hash' do
        expect(seo_params.all).to be_a(Hash)
      end
      it 'returns information about domain' do

      end
    end
  end
  context 'with proxy' do
    describe ".new" do
      it 'creates new instance' do
        expect(MetricsCrawler::SeoParams.new(url, proxy)).to be_a(MetricsCrawler::SeoParams)
      end
    end
  end
end
