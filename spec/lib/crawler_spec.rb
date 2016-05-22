require 'metrics_crawler/crawler'

describe 'Crawler' do
  let! (:crawler) { build(:crawler) }

  describe '#run' do
    it 'responds to method #run' do
      expect(crawler).to respond_to(:run)
    end
  end
end
