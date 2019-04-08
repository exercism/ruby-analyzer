EXERCISES = %w{
  two_fer
}

FILENAMES = {
  "two-fer" => "two_fer.rb"
}

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
  def self.analyze(exercise_slug, path)
    pathname = Pathname.new(path)
    AnalyzeSolution.(exercise_slug, pathname)
  end
end
