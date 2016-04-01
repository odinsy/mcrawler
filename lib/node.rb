class Node
  attr_accessor :link, :port
  def initialize(attributes)
    @link = attributes[:link]
    @port = attributes[:port]
  end
end
