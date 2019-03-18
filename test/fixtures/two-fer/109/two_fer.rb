module TwoFer
  def self.two_fer(who = nil)
    fer = who ? who : 'you'
    "One for #{fer}, one for me."
  end
end
