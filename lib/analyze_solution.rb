class AnalyzeSolution
  include Mandate

  initialize_with :exercise_slug, :path

  def call
    code_to_analyze = File.read(path / FILENAMES[exercise_slug])

    classified_exercise = exercise_slug.tr('-', '_').classify
    results = "#{classified_exercise}::Analyze".constantize.(code_to_analyze)

    File.open(path / "analysis.json","w") do |f|
      f.write(results.to_json)
    end
  end
end
