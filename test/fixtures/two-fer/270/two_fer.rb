class TwoFer
  def self.two_fer *args
    name = args[0] || "you"
    "One for #{name}, one for me."
  end
end