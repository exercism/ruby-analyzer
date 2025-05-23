module Leap
  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      if solution.uses_std_lib?
        self.status = :disapprove
        self.comments = ["ruby.leap.std_lib"]
      else
        self.status = :refer_to_mentor
      end

      raise FinishedFlowControlException
    end
  end
end
