require 'metrics_crawler/config'
require 'stringio'

describe 'Config' do
  let!(:config) { build(:config) }
  let!(:config_path) { File.expand_path("../../data/new_config.yml", __FILE__) }

  context '.new' do
    it 'responds to method .new' do
      expect(MetricsCrawler::Config).to respond_to(:new)
    end

    it 'creates a new instance' do
      expect(MetricsCrawler::Config.new).to be_a(MetricsCrawler::Config)
    end
  end

  context '.generate' do
    it 'responds to method .generate' do
      expect(MetricsCrawler::Config).to respond_to(:generate)
    end

    context "when configuration file doesn't exist" do
      before { File.delete(config_path) if File.exist?(config_path) }
      it 'displays a message about generated file' do
        expect { MetricsCrawler::Config.generate(config_path) }.to output(/Generated configuration file: #{config_path}/).to_stdout
      end
      it 'generates the configuration file' do
        MetricsCrawler::Config.generate(config_path)
        expect(File).to exist(config_path)
      end
    end

    context "when configuration file is already exists" do
      before :each do
        $stdin = StringIO.new("yes")
        File.delete(config_path) if File.exist?(config_path)
      end
      after do
        $stdin = STDIN
      end
      it 'asks whether you want to overwrite file' do
        MetricsCrawler::Config.generate(config_path)
        expect { MetricsCrawler::Config.generate(config_path) }.to output(/Would you like to overwrite the configuration file?/).to_stdout
      end
    end
  end

  context '.capture_answer' do
    before do
      $stdin = StringIO.new("yes")
    end
    after do
      $stdin = STDIN
    end
    context 'when gets "yes"' do
      it 'should be "yes"' do
        expect(MetricsCrawler::Config.send(:capture_answer)).to eq('yes')
      end
    end
  end

  context '.overwrite?' do
    context "when asked 'yes'" do
      before do
        $stdin = StringIO.new("yes")
      end
      after do
        $stdin = STDIN
      end
      it "returns 'true'" do
        expect(MetricsCrawler::Config.send(:overwrite?)).to be_truthy
      end
    end

    context "when asked 'no'" do
      before do
        $stdin = StringIO.new("no")
      end
      after do
        $stdin = STDIN
      end
      it "returns 'false'" do
        expect(MetricsCrawler::Config.send(:overwrite?)).to be_falsey
      end
    end

    context "when asked something else" do
      before do
        $stdin = StringIO.new("bla")
      end
      after do
        $stdin = STDIN
      end
      it "returns 'Invalid choice'" do
        expect{ MetricsCrawler::Config.send(:overwrite?) }.to output(/Invalid input./).to_stdout
      end
    end
  end
end
