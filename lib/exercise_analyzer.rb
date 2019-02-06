require 'json'
require 'active_support/inflector'

class ExerciseAnalyzer
  def self.analyze(exercise, path)
    classified_exercise = exercise.tr('-', '_').classify
    analyzer = "#{classified_exercise}Analyzer".constantize.new(path)
    analyzer.analyze!
    analyzer.report!
  end

  def initialize(path)
    @path = Pathname.new(path)
    @approve = false
  end

  def report!
    File.open(path / "analysis.json","w") do |f|
      f.write(results.to_json)
    end
  end

  private
  attr_reader :path, :approve

  def results
    {
      approve: approve
    }
  end
end
