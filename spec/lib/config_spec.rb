require 'metrics_crawler/config'

describe 'Crawler' do
  let!(:config) { build(:config) }
  let!(:config_path) { File.expand_path("../../data/new_config.yml", __FILE__) }

  context '.generate' do
    it 'respond to method .generate' do
      expect(MetricsCrawler::Config).to respond_to(:generate)
    end
    it 'generates the configuration file' do
      MetricsCrawler::Config.generate(config_path)
      expect(config_path).to be_an_existing_file
    end
  end
end
