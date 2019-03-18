class TwoFer
  def self.two_fer(name=nil)
    return name == nil ? "One for you, one for me." : "One for #{name}, one for me."
  end
end
