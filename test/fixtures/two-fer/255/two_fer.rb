class TwoFer
  def self.two_fer(*args)
    if args.empty?
      "One for you, one for me."
    else
      "One for #{args[0]}, one for me."
    end
  end
end