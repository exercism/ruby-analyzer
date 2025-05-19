module Leap
  class Representation < SolutionRepresentation
    def uses_std_lib?
      date_node = SA::Helpers.extract_nodes(:const, target_method).find { |node| node.const_name == 'Date' }
      return false if date_node.nil?

      date_node.parent.children.any? { |node| %i[leap? gregorian_leap? julian_leap?].include? node }
    end

    private
    def target_module
      SA::Helpers.extract_module_or_class(root_node, "Year")
    end

    def target_method
      SA::Helpers.extract_module_method(target_module, "leap?")
    end
  end
end
