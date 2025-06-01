module HighScores
  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      if solution.uses_accepted_solution?
        approve_if_whitespace_is_sensible
      elsif solution.needs_attr_reader?
        approve_if_whitespace_is_sensible("ruby.high-scores.attr_reader")
      else
        refer_to_mentor
      end
    end
  end
end
