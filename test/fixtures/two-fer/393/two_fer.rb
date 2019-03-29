class TwoFer
  def self.two_fer(*a)
    if a.empty?
      return "One for you, one for me."
    end
    return "One for #{a[0]}, one for me."
  end
end
