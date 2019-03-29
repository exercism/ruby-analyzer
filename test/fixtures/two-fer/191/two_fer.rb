require 'pry'

class TwoFer
    def self.two_fer(name = null)
        "One for you, one for me."
    end

    def self.two_fer(name = 'Alice')
        "One for #{name}, one for me."
    end

    def self.two_fer(name = 'Bob')
        "One for #{name}, one for me."
    end
end