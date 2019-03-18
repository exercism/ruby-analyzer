module TwoFer
  def self.two_fer(name = nil)
    "One for #{name.nil? ? "you" : name}, one for me."
  end
end