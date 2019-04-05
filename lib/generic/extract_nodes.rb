module SA
  class ExtractNodes < Parser::AST::Processor
    include Mandate

    def initialize(node_type, node_to_search)
      @node_to_search = node_to_search
      @found_methods = []

      define_singleton_method "on_#{node_type}" do |node|
        found_methods << node
      end
    end

    def call
      process(node_to_search)
      found_methods
    end

    private
    attr_reader :node_to_search, :found_methods
  end
end
