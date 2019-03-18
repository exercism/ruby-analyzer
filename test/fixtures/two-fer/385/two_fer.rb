class TwoFer
  class << self
    def two_fer(name = nil)
      if name == nil
        return "One for you, one for me."
      else
        "One for #{name}, one for me."
      end
    end
  end
end
