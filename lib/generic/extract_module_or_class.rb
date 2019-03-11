module SA
  class ExtractModuleOrClass < Parser::AST::Processor
    include Mandate

    def initialize(node_to_search, name)
      @node_to_search = node_to_search
      @name = name
      @found_constant = nil
    end

    def call
      process(node_to_search)
      found_constant
    end

    def on_module(node)
      inspect_node(node)
    end

    def on_class(node)
      inspect_node(node)
    end

    private
    attr_reader :node_to_search, :name, :found_constant

    def inspect_node(node)
      if node.children.first.const_name == name
        @found_constant = node
      end
    end
  end
end
