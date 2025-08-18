require "test_helper"

class AnalyzerTest < Minitest::Test
  TMP_PATH = Pathname.new('/tmp')

  protected
  attr_reader :exercise_slug

  def analysis_results(code = "")
    solution_path = "#{TMP_PATH}/#{FILENAMES[exercise_slug]}"
    analysis_path = "#{TMP_PATH}/#{ANALYSIS_FILENAME}"
    File.open(solution_path, "w") do |f|
      f.write("#{code}\n")
    end
    AnalyzeSolution.(exercise_slug, TMP_PATH, TMP_PATH)
    JSON.parse(File.read(analysis_path))
  ensure
    File.delete solution_path if File.exist? solution_path
    File.delete analysis_path if File.exist? analysis_path
  end
end
