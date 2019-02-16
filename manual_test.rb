$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "analyzer"
require 'pp'
require 'pry'

source = %q{
  module TwoFer
    def self.two_fer(name=nil)
      if name == nil
        "One for you, one for me."
      else
        "One for #{name}, one for me."
      end
    end
  end
}

puts "\n\n\n\n"
pp TwoFer::Analyze.(source)
puts "\n\n\n\n"
