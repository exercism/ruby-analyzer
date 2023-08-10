class TwoFer
  def self.two_fer(name="you")
    if name == 'you'
      "One for you, one for me."
    else
      "One for #{str}, one for me."
    end
  end
end
