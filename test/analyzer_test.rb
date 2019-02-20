require "test_helper"

class AnalyzerTest < Minitest::Test
  def test_that_it_converts_to_path_and_runs
    slug = mock
    path = mock
    pathname = mock
    Pathname.expects(:new).with(path).returns(pathname)

    AnalyzeSolution.expects(:call).with(slug, pathname)
    Analyzer.analyze(slug, path)
  end
end
