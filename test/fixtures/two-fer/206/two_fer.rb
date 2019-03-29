class TwoFer
  def self.two_fer *n
    case n.size
    when 0
        "One for you, one for me."
    else
        "One for #{n[0]}, one for me."
    end
  end
end