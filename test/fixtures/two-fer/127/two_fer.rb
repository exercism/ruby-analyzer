module TwoFer
  def self.two_fer(name='you')
    unless ARGV.empty?
      name = ARGV
    end
      "One for #{name}, one for me."
  end
end
