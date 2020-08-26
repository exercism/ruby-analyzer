require "test_helper"

class AnalyzerTest < Minitest::Test
  def test_that_it_converts_to_path_and_runs
    slug = mock
    solution_path = mock
    output_path = mock
    solution_pathname = mock
    output_pathname = mock
    Pathname.expects(:new).with(solution_path).returns(solution_pathname)
    Pathname.expects(:new).with(output_path).returns(output_pathname)

    AnalyzeSolution.expects(:call).with(slug, solution_pathname, output_pathname)
    Analyzer.analyze(slug, solution_path, output_path)
  end
end
