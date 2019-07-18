module Acronym
  class Representation < SolutionRepresentation
    def uses_method_chain?
      matchers = [
        {
          method_name: :upcase,
        },
        {
          method_name: :join,
          chained?: true
        },
        {
          method_name: :map,
          arguments: [{ to_ast: s(:block_pass, s(:sym, :chr)) }],
          chained?: true
        },
        {
          method_name: :split,
          chained?: true
        },
        {
          method_name: :tr,
          receiver: s(:lvar, :words),
          chained?: true,
          arguments: [{ to_ast: s(:str, "-") }, { to_ast: s(:str, " ") }]
        }
      ]

      matches?(target_method.body, matchers)
    end

    def uses_scan?
      matchers = [
        {
          method_name: :upcase,
        },
        {
          method_name: :join,
          chained?: true
        },
        {
          method_name: :scan,
          receiver: s(:lvar, :words),
          chained?: true,
          arguments: [{ type: :regexp }]
        },
      ]

      matches?(target_method.body, matchers)
    end

    def uses_split?
      matchers = [
        {
          method_name: :upcase,
        },
        {
          method_name: :join,
          chained?: true
        },
        {
          method_name: :map,
          chained?: true,
          arguments: [{ to_ast: s(:block_pass, s(:sym, :chr)) }]
        },
        {
          method_name: :split,
          receiver: s(:lvar, :words),
          arguments: [{ type: :regexp }]
        }
      ]

      matches?(target_method.body, matchers)
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

    def matches?(body, matchers)
      body.
        each_node(:send).
        with_index.
        all? { |node, i| node_matches?(node, matchers[i]) }
    end

    def node_matches?(node, matcher)
      matcher.
        map do |criteria|
          key, expected_value = *criteria
          criteria_value = node.send(key)

          case criteria_value
          when Array
            criteria_value.each_with_index.all? do |n, i|
              node_matches?(n, expected_value[i])
            end
          else
            criteria_value == expected_value
          end
        end.
        all?
    end
  end
end
