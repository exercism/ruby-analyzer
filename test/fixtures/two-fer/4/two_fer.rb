class TwoFer
  def self.two_fer(*args)
    if args.length > 0
      name, rest  = args
      return "One for #{name}, one for me."
    else
      return "One for you, one for me."
    end
  end
end
