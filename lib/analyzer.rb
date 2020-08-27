EXERCISES = %w[
  two_fer
  acronym
].freeze

FILENAMES = {
  "two-fer" => "two_fer.rb"
}.freeze

require 'mandate'
require 'json'
require 'rubocop'
require 'parser/current'
require 'active_support/inflector'

require_relative "generic/helpers"
require_relative "generic/extract_module_method"
require_relative "generic/extract_instance_method"
require_relative "generic/extract_module_or_class"
require_relative "generic/extract_nodes"

require_relative 'analyze_solution'

require_relative 'analyzers/exercise_analyzer'
require_relative "analyzers/solution_representation"
EXERCISES.each do |exercise|
  require_relative "analyzers/#{exercise}/analyze"
  require_relative "analyzers/#{exercise}/representation"
end

module Analyzer
  def self.analyze(exercise_slug, solution_path, output_path)
    solution_pathname = Pathname.new(solution_path)
    output_pathname = Pathname.new(output_path)
    AnalyzeSolution.(exercise_slug, solution_pathname, output_pathname)
  end
end
