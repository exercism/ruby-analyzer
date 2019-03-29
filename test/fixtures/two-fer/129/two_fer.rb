class TwoFer
    def self.two_fer(name="")
        whom = name == "" ? "you" : name
        "One for #{whom}, one for me."
    end
end