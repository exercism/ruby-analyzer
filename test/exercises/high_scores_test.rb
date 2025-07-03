require "test_helper"

class HighScoresTest < AnalyzerTest
  def setup
    @exercise_slug = "high-scores"
  end

  def test_accepted_solution_is_approved_without_comment
    source = <<~SOURCE
      class HighScores
        attr_reader :scores

        def initialize(scores)
          @scores = scores
        end

        def personal_best
          scores.max
        end

        def latest
          scores.last
        end

        def personal_top_three
          scores.max(3)
        end

        def latest_is_personal_best?
          latest == personal_best
        end
      end
    SOURCE

    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end

  def test_solution_without_attr_reader_is_approved_with_comment
    source = <<~SOURCE
      class HighScores
        def initialize(scores)
          @scores = scores
        end

        def scores
          @scores
        end

        def personal_best
          scores.max
        end

        def latest
          scores.last
        end

        def personal_top_three
          scores.max 3
        end

        def latest_is_personal_best?
          latest == personal_best
        end
      end
    SOURCE

    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_equal ["ruby.high-scores.attr_reader"], results["comments"]
  end

  def test_reordered_accepted_solution_is_approved_without_comment
    source = <<~SOURCE
      class HighScores
        attr_reader :scores

        def initialize(scores)
          @scores = scores
        end

        def latest
          scores.last
        end

        def personal_best
          scores.max
        end

        def personal_top_three
          scores.max(3)
        end

        def latest_is_personal_best?
          latest == personal_best
        end
      end
    SOURCE

    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end

  def test_non_accepted_solution_is_referred_to_mentor
    source = <<~SOURCE
      class HighScores
        attr_reader :scores

        def initialize(scores)
          @scores = scores
        end

        def latest
          scores.last
        end

        def personal_best
          scores.sort.last
        end

        def personal_top_three
          scores.max(3)
        end

        def latest_is_personal_best?
          latest == personal_best
        end
      end
    SOURCE

    results = analysis_results(source)
    assert_equal "refer_to_mentor", results["status"]
    assert_empty results["comments"]
  end

  def test_solution_with_incorrect_indentation_is_disapproved
    source = <<~SOURCE
      class HighScores
        attr_reader :scores

        def initialize(scores)
         @scores = scores
        end

        def personal_best
           scores.max
        end

        def latest
         scores.last
        end

        def personal_top_three
          scores.max(3)
        end

        def latest_is_personal_best?
          latest == personal_best
        end
      end
    SOURCE

    results = analysis_results(source)
    assert_equal "disapprove", results["status"]
    assert_equal ["ruby.general.incorrect_indentation"], results["comments"]
  end
end
