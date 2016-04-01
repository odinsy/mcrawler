class NodeList
  attr_accessor :list
  def initialize(path)
    @list = load_data(path).map { |node| Node.new(node) }
  end

  private

  def load_data
  end
end
