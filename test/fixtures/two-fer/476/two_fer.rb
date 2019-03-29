class TwoFer

  def self.two_fer(name = nil)
    unless name == nil
      "One for #{name}, one for me."
    else
      "One for you, one for me."
    end
  end
end