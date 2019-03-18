class TwoFer
  def self.two_fer(name=nil)
    return "One for #{name == nil ? "you" : name}, one for me."
  end
end
