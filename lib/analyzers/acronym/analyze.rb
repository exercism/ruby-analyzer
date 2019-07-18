module Acronym
  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      if solution.uses_method_chain?
        self.status = :approve

        raise FinishedFlowControlException
      end
    end
  end
end
