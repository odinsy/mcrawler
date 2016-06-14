module MetricsCrawler
  # MetricsCrawler::Nodes class
  # @example
  #   nodes = MetricsCrawler::Nodes.new(["node01", "node02"])
  class Nodes
    attr_reader :nodes

    # Creates a new MetricsCrawler::Nodes object
    # @param [Array] nodes                  Input array of nodes
    # @attr [Array] nodes                   Returns of nodes
    def initialize(nodes)
      @nodes = prepare_nodes(nodes) unless nodes.nil?
    end

    private
    # Nodes preparation
    # Every node will be parsed by URI.parse, encoded and converted to String
    # @param [Array] nodes                  Input array of nodes
    def prepare_nodes(nodes)
      nodes.map { |node| URI.parse(URI.encode(node)).to_s }
    end
  end
end
