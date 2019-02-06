require "test_helper"

class AnalyzerTest < Minitest::Test
  def test_that_it_runs
    exercise = mock
    path = mock

    ExerciseAnalyzer.expects(:analyze).with(exercise, path)
    Analyzer.analyze(exercise, path)
  end
end
