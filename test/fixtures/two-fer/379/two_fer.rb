module TwoFer
  def TwoFer.two_fer(name = nil)
    if name
      return "One for #{name}, one for me."
    else
      return "One for you, one for me."
    end
  end
end