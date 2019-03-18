class TwoFer
    def self.two_fer(name = "you")
        "One for #{name}, one for me."
    end
end

p TwoFer.two_fer
p TwoFer.two_fer("Alice")
p TwoFer.two_fer("Bob")