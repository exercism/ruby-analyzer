class TwoFer
  def self.two_fer(name = "you")

    return "One for #{name}, one for me."
  end
end


puts TwoFer.two_fer("Bob")
puts TwoFer.two_fer()
