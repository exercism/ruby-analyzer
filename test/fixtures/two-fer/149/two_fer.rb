class TwoFer
  DEFAULT_NAME = 'you'.freeze

  def self.two_fer(name = DEFAULT_NAME)
    "One for #{name}, one for me."
  end
end
