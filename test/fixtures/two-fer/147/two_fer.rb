class TwoFer
  PLACEHOLDER = "you"

  def self.two_fer(name = nil)
    name ||= PLACEHOLDER
    "One for #{name}, one for me."
  end
end
