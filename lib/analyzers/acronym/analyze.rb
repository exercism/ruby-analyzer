module Acronym
  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      if solution.uses_method_chain? || solution.uses_scan?
        self.status = :approve

        raise FinishedFlowControlException
      end
    end
  end
end
