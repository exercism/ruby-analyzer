class TwoFer

  # def self.two_fer
  #   return "One for you, one for me."
  # end 

  def self.two_fer(arg1="you")
    return "One for #{arg1}, one for me."

  end 

end 

puts TwoFer.two_fer
puts TwoFer.two_fer("Alice")
puts TwoFer.two_fer("Bob")

