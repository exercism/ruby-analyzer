class TwoFer
    def self.two_fer(name = "")
        return name.empty? ?  "One for you, one for me." :  "One for #{name}, one for me."        
    end
end