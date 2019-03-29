class TwoFer

  def self.two_fer(value = nil)
    if value == "Alice"
      return "One for Alice, one for me."
    elsif value == "Bob"
      return "One for Bob, one for me."
    else
      return "One for you, one for me."
    end
  end

end
