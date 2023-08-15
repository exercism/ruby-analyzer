class AnalyzeSolution
  include Mandate

  initialize_with :exercise_slug, :solution_path, :output_path

  def call
    code_to_analyze = File.read(solution_path / FILENAMES[exercise_slug])

    puts "Analysing #{exercise_slug}"
    classified_exercise = exercise_slug.tr('-', '_').classify
    results = "#{classified_exercise}::Analyze".constantize.(code_to_analyze)

    File.open(output_path / "analysis.json", "w") do |f|
      f.write("#{results.to_json}\n")
    end
  end
end
