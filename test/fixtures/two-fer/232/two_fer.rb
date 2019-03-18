module TwoFer
  def self.two_fer(name = "you")
    "One for #{name}, one for me."
  end
end

# Testing on command line 
# puts TwoFer.two_fer
# puts TwoFer.two_fer(ARGV[0])
