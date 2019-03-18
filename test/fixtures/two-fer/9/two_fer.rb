module TwoFer

  def self.two_fer(name = nil)
    if name == "Alice"
      "One for Alice, one for me."
    elsif name == "Bob"
      "One for Bob, one for me."
    else
      "One for you, one for me."
    end
  end

end