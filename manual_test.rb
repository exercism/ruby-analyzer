$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "analyzer"
require 'pp'
require 'pry'

source = %q{
  class TwoFer
    class << self
      def two_fer(name="you")
        "One for #{name}, one for me."
      end
      def foobar
      end
    end
  end
}

puts "\n\n\n\n"
pp TwoFer::Analyze.(source)
puts "\n\n\n\n"
