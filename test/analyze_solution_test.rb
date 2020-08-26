require "test_helper"

class AnalyzeSolutionTest < Minitest::Test

  def test_that_it_constantizes_correctly
    code = mock
    analyzer = mock
    results_json = mock
    results = mock(to_json: results_json)

    File.expects(:read).with(SOLUTION_PATH / "two_fer.rb").returns(code)
    File.expects(:open).
      with(SAFE_WRITE_PATH / "analysis.json", "w").yields(
        mock(write: results_json)
      )
    TwoFer::Analyze.expects(:new).with(code).returns(analyzer)
    analyzer.expects(:call).returns(results)
    AnalyzeSolution.('two-fer', SOLUTION_PATH, SAFE_WRITE_PATH)
  end
end
