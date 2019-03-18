class TwoFer
  def self.two_fer(you = nil)
    if you
      return "One for #{you}, one for me."
    else
      return "One for you, one for me."
    end
  end
end