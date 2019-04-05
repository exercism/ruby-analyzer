$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "analyzer"
require 'pp'
require 'pry'

source = %q{
class TwoFer
    def self.two_fer(name = "you")
        return ("One for " + name + ", one for me.")
    end
end

}

puts "\n\n\n\n"
pp TwoFer::Analyze.(source)
puts "\n\n\n\n"
