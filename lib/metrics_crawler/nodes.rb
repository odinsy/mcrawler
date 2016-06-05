module MetricsCrawler
  module Nodes
    # Подготовка нод
    def prepare_nodes(nodes)
      nodes.map { |node| URI.parse(URI.encode(node)).to_s }
    end
  end
end
