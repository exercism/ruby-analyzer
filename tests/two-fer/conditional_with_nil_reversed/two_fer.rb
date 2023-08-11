module TwoFer
  def self.two_fer(name=nil)
    if nil == name
      "One for you, one for me."
    else
      "One for #{name}, one for me."
    end
  end
end
