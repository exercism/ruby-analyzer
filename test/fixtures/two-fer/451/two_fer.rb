# conditional.rb


class TwoFer
  def self.two_fer(str = nil)
    if str
      "One for #{str}, one for me."
    else
      "One for you, one for me."
    end
  end
end
