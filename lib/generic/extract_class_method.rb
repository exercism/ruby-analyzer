class ExtractClassMethod < Parser::AST::Processor
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

  def on_sclass(node)
    # If we're in a class << self context
    if node.children[0].self_type?
      @found_method = ExtractInstanceMethod.(node.children[1], name)
    end
  end

  def on_defs(node)
    if node.method_name == name
      @found_method = node
    end
  end

  private
  attr_reader :node_to_search, :name, :found_method
end
