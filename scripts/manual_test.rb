$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "analyzer"
require 'pp'
require 'pry'

source = %q{
class TwoFer
    def self.two_fer(name = nil)
       name = "you" if name.nil?

       "One for #{name}, one for me."
    end
end
}

puts "\n\n\n\n"
pp TwoFer::Analyze.(source)
puts "\n\n\n\n"
