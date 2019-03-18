class TwoFer 

  def self.two_fer(*var) 
    x = var[0]
    if x.nil?
      return "One for you, one for me."
    end
    return "One for #{var[0]}, one for me."
  end

end
