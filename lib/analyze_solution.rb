class AnalyzeSolution
  include Mandate

  initialize_with :exercise_slug, :solution_path, :output_path

  def call
    code_to_analyze = File.read(solution_path / FILENAMES[exercise_slug])

    classified_exercise = exercise_slug.split('-').map(&:capitalize).join
    results = "#{classified_exercise}::Analyze".constantize.(code_to_analyze)

    File.open(output_path / ANALYSIS_FILENAME, "w") do |f|
      f.write("#{results.to_json}\n")
    end
  end
end
