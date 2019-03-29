class TwoFer
  def self.two_fer(n="")
    if n == ""
      "One for you, one for me."
    elsif n == "Alice"
      "One for #{n}, one for me."
    elsif n == "Bob"
      "One for #{n}, one for me."
    else
      "I don't recognize that name."
    end
  end
end


# Ask for the name
puts "Please type in a name: "
# Store the name
name = gets.chomp
# Call the two_fer method
TwoFer.two_fer(name)
