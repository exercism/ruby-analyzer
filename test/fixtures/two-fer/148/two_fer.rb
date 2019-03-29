module TwoFer
    def self.two_fer(name = nil)
        if name == nil
            name = "you"
        end
        "One for #{name}, one for me."
    end
end
