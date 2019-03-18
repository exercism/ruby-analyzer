
class TwoFer
  def self.two_fer(*n)
    name = n[0]
    if name == nil
      name = "you"
    end
    "One for #{name}, one for me."
  end
end
