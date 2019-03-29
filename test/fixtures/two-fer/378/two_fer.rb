module TwoFer
  def self.two_fer(*name)
    if name.length < 1
      "One for you, one for me."
    else
      "One for #{name[0]}, one for me."
    end
  end
end