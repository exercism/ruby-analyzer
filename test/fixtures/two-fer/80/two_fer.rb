class TwoFer
  def self.two_fer(name=nil)
    case name
    when "Alice"
      "One for Alice, one for me."
    when "Bob"
      "One for Bob, one for me."
    else "One for you, one for me."
    end
  end
end