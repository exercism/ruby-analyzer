require 'pry'
module HighScores
  class Representation < SolutionRepresentation
    APPROVED_METHODS = {
      personal_best: ["scores.max"],
      latest: ["scores.last"],
      personal_top_three: ["scores.max(3)", "scores.max 3"],
      latest_is_personal_best?: ["latest == personal_best"]
    }.freeze

    def uses_accepted_solution?
      has_correct_number_of_methods? && implements_approved_methods? && implements_attr_reader? && implements_initialize?
    end

    def needs_attr_reader?
      has_correct_number_of_methods? && implements_approved_methods? && implements_initialize? && implements_scores?
    end

    private
    memoize
    def target_class_body
      SA::Helpers.extract_module_or_class(root_node, "HighScores").children.compact.find { |n| n.type == :begin }
    end

    memoize
    def method_definitions
      target_class_body.children.select { |node| node.type == :def }
    end

    def has_correct_number_of_methods?
      target_class_body.children.count == 6
    end

    memoize
    def implements_approved_methods?
      APPROVED_METHODS.all? do |method_name, method_bodies|
        method_node = method_definitions.find { |node| node.method_name == method_name }
        method_node && method_bodies.include?(method_node.body.source)
      end
    end

    memoize
    def implements_initialize?
      initialize_node = method_definitions.find { |node| node.method_name == :initialize }
      initialize_node && initialize_node.source.lines[0..1].map(&:strip) == ["def initialize(scores)", "@scores = scores"]
    end

    def implements_attr_reader?
      attr_reader_node = target_class_body.children.find { |node| node.type == :send }
      attr_reader_node && attr_reader_node.source == "attr_reader :scores"
    end

    def implements_scores?
      scores_node = method_definitions.find { |node| node.method_name == :scores }
      scores_node && scores_node.body.source == "@scores"
    end
  end
end
