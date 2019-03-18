#!/usr/bin/env ruby
# two_fer.rb, Viktor Godard

# say two fer
module TwoFer
  def self.two_fer
    return 'you' if ARGV.empty?

    ARGV[0]
  end
end

puts "One for #{TwoFer.two_fer}, one for me."
