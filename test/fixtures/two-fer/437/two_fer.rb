module TwoFer
  def self.two_fer(*name)
    name.empty? ? "One for you, one for me." : "One for #{name[0]}, one for me."
  end
end