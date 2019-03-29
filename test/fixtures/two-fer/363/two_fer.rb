class TwoFer
  def self.two_fer(n=nil)
    nomme = n.nil? ? "you" : n
    "One for #{nomme}, one for me."
  end  
end