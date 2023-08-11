module TwoFer
  def self.two_fer(name='dog')
    if name == 'dog'
      "One for you, one for me."
    else
      "One for #{name}, one for me."
    end
  end
end
