class TwoFer
    # def self.two_fer
    #     # names.name = ["you", "Alice", "Bob"]
    #     names = ['you', 'Alice', 'Bob']

    #     names.each do |name|
    #         puts "One for #{name}, one for me."
    #     end
    # end

    # def self.two_fer
    #     name = ""
    #     if name == ""
    #      "One for you, one for me."
    #     elsif name == "Alice"
    #         "One for Alice, one for me."
    #     elsif name == "Bob"
    #         "One for Bob, one for me."

    #     end

    # end

    def self.two_fer(name = "you")
        "One for #{name}, one for me."
    end

end
