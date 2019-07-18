module Acronym
  class Analyze < ExerciseAnalyzer
    include Mandate

    MESSAGES = {
      use_shorthand_block_syntax: "ruby.acronym.block_syntax.shorthand", # "Use ruby's short hand block syntax to be more concise"
    }

    def analyze!
      approve! if approve_without_comment?

      approve!(:use_shorthand_block_syntax) if solution.uses_method_chain_with_block?
    end

    private

    def approve_without_comment?
      solution.uses_method_chain? || solution.uses_scan? || solution.uses_split?
    end

    def approve!(msg = nil)
      self.comments << MESSAGES[msg] if msg
      self.status = :approve

      raise FinishedFlowControlException
    end
  end
end
