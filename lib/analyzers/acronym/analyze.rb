module Acronym
  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      if solution.uses_method_chain? || solution.uses_scan? || solution.uses_split?
        self.status = :approve

        raise FinishedFlowControlException
      end
    end
  end
end
