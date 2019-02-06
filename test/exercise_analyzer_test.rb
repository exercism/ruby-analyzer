require "test_helper"

class ExerciseAnalyzerTest < Minitest::Test

  class ::SomeFakeExerciseAnalyzer < ExerciseAnalyzer
  end

  def test_that_it_constantizes_correctly
    SomeFakeExerciseAnalyzer.any_instance.expects(:analyze!)
    SomeFakeExerciseAnalyzer.any_instance.expects(:report!)
    ExerciseAnalyzer.analyze('some_fake-exercise', SAFE_WRITE_PATH)
  end
end
