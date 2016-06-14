module MetricsCrawler
  # MetricsCrawler::Nodes class
  # @example
  #   nodes = MetricsCrawler::Nodes.new(["http://node01.example.com", "http://node02.example.com"])
  #
  class Nodes
    attr_reader :nodes
    # Creates a new MetricsCrawler::Nodes object
    # @param [Array] nodes                  Input array of nodes
    # @attr [Array] nodes                   Array of nodes
    #
    def initialize(nodes)
      @nodes = prepare_nodes(nodes) unless nodes.nil?
    end

    private
    # Nodes preparation
    # Every node will be parsed by URI.parse, encoded and converted to String
    # @return [Array]                       Array of parsed and encoded nodes
    # @param [Array] nodes                  Input array of nodes
    #
    def prepare_nodes(nodes)
      nodes.map { |node| URI.parse(URI.encode(node)).to_s }
    end
  end
end
