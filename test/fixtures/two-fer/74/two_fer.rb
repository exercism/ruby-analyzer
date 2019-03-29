class TwoFer
    MESSAGE = "One for %s, one for me."

    def self.two_fer(name = "you")
        MESSAGE % [name]
    end
end