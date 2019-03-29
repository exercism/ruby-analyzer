module TwoFer
 def self.two_fer(name = "you")
   name.nil? ? "One for #{name}, one for me." : "One for #{name}, one for me."
 end
end
