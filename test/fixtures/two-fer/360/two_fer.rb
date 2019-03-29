module TwoFer
  def self.two_fer(x = nil)
    if x
      return "One for #{x}, one for me."
    else
      "One for you, one for me."
    end
  end
end
