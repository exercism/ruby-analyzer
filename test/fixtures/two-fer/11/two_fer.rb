module TwoFer 
    def self.two_fer(name: nil)
        if name.nil?
            name = "you"
        end
      return "One for #{name}, one for me."
    end
  end