module Acronym
  class Representation < SolutionRepresentation

    def uses_method_chain?
      target_method.body == s(:send,
                              s(:send,
                                s(:send,
                                  s(:send,
                                    s(:send, s(:lvar, :words), :tr, s(:str, "-"), s(:str, " ")),
                                    :split
                                   ),
                                   :map,
                                  s(:block_pass, s(:sym, :chr))
                                 ),
                                 :join),
                              :upcase)
    end

    private
    memoize
    def target_method
      SA::Helpers.extract_module_method(target_module, "abbreviate")
    end

    memoize
    def target_module
      SA::Helpers.extract_module_or_class(root_node, "Acronym")
    end
  end
end
