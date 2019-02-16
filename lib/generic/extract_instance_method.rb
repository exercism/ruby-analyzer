class ExtractInstanceMethod < Parser::AST::Processor
  include Mandate

  def initialize(node_to_search, name)
    @node_to_search = node_to_search
    @name = name.to_sym
    @found_method = nil
  end

  def call
    process(node_to_search)
    found_method
  end

  def on_def(node)
    if node.method_name == name
      @found_method = node
    end
  end

  private
  attr_reader :node_to_search, :name, :found_method
end
