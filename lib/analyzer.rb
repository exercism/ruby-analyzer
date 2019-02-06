EXERCISES = %w{
  two_fer
}

require_relative 'exercise_analyzer'

EXERCISES.each do |exercise|
  require_relative "exercises/#{exercise}/analyzer"
end

module Analyzer
  def self.analyze(exercise, path)
    ExerciseAnalyzer.analyze(exercise, path)
  end
end
