require 'metrics_crawler/config'

describe 'Crawler' do
  let!(:config) { build(:config) }
  let!(:config_path) { File.expand_path("../../data/new_config.yml", __FILE__) }

  describe '.generate' do
    it 'respond to method .generate' do
      expect(MetricsCrawler::Config).to respond_to(:generate)
    end
    context 'configuration file' do
      after :each do
        File.delete(config_path)
      end
      it 'displays a message about generated file' do
        expect { MetricsCrawler::Config.generate(config_path) }.to output(/Generated configuration file: #{config_path}/).to_stdout
      end
      it 'generates the configuration file' do
        MetricsCrawler::Config.generate(config_path)
        expect(File).to exist(config_path)
      end
    end
  end
end
