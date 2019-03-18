class TwoFer

  def self.two_fer(name=nil)
    case name
    when nil
      "One for you, one for me."
    else
      "One for #{name}, one for me."
    end
  end

end
