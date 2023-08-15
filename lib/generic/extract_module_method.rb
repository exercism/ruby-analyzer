module SA
  class ExtractModuleMethod < Parser::AST::Processor
    include Mandate

    def initialize(node_to_search, name)
      @node_to_search = node_to_search
      @name = name.to_sym
      @found_method = nil
      @found_instance_method = nil

      @module_function_called = false
      super()
    end

    def call
      process(node_to_search)
      found_method
    end

    def on_sclass(node)
      # If we're in a class << self context
      @found_method = ExtractInstanceMethod.(node.children[1], name) if node.children[0].self_type?
    end

    def on_def(node)
      return unless node.method_name == name

      if @module_function_called
        @found_method = node
      else
        @found_instance_method = node
      end
    end

    def on_defs(node)
      # Return unless the name matches
      return unless node.method_name == name

      # Is this defined as self (where there is no constant)
      # or on a specific module, and if so is this module the
      # correct one?
      defined_on = node.children[0].const_name
      return unless defined_on.nil? || defined_on == module_name

      @found_method = node
    end

    # We want to see if we have the syntax:
    #   module_function
    #   def foobar
    #   end
    def on_send(node)
      return unless node.method_name == :module_function

      if node.arguments?
        return unless @found_instance_method

        if node.arguments.map(&:value).include?(name)
          @found_method = @found_instance_method
          @found_instance_method = nil
        end
      else
        @module_function_called = true
      end
    end

    private
    attr_reader :node_to_search, :name,
                :found_method,
                :found_instance_method, :module_function_called

    memoize
    def module_name
      node_to_search.children[0].const_name
    end
  end
end
