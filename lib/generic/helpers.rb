module SA
  module InlineHelpers
    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end
  end

  module Helpers
    def self.extract_module_or_class(*args)
      ExtractModuleOrClass.(*args)
    end

    def self.extract_module_method(*args)
      ExtractModuleMethod.(*args)
    end

    def self.extract_nodes(*args)
      ExtractNodes.(*args)
    end

    def self.extract_first_line_from_method(method)
      # A begin block signifies multiple lines
      # so we return the first line.
      return method.body.children.first if method.body.type == :begin

      # Without a begin block we just have one line,
      # so we return the method body, which *is* the first line
      return method.body
    end

    def self.num_lines_in_method(method)
      method.body.child_nodes.size
    end

    # Is this an lvar (local variable) with a given name?
    def self.lvar?(node, name)
      node.lvar_type? && node.children[0] == name
    end

    def self.extract_conditional_clause(loc)
      loc.children[0]
    end
  end
end
