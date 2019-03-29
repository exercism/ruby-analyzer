class TwoFer
  def self.two_fer(name = "you")
    sprintf("One for %s, one for me.", name || "you")
  end
end
