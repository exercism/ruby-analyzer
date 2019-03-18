TwoFer = Class.new do
  define_singleton_method(:two_fer) do |you = 'you'|
    "One for #{you}, one for me."
  end

  self
end
