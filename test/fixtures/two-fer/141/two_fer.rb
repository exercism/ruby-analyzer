class TwoFer
  def self.two_fer(name = nil)
    @name = name || 'you'
    "One for #{@name}, one for me."
  end
end
