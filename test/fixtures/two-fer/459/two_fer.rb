module TwoFer
  def self.two_fer(name = nil)
    if name.nil?
      "One for you, one for me."
    else
      "One for #{name}, one for me."
    end
  end
end