module Acronym
  class Analyze < ExerciseAnalyzer
    include Mandate

    MESSAGES = {
      use_shorthand_block_syntax: "ruby.acronym.block_syntax.shorthand", # "Use ruby's short hand block syntax to be more concise"
    }

    def analyze!
      approve! if solution.uses_method_chain?
      approve! if solution.uses_scan?
      approve! if solution.uses_split?
      approve!(:use_shorthand_block_syntax) if solution.uses_method_chain_with_block?

      refer_to_mentor!
    end

    private

    def approve!(msg = nil)
      self.comments << MESSAGES[msg] if msg
      self.status = :approve

      raise FinishedFlowControlException
    end

    def refer_to_mentor!
      self.status = :refer_to_mentor

      raise FinishedFlowControlException
    end
  end
end
