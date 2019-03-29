module TwoFer
  module ClassMethods
    def two_fer(name = 'you')
      "One for #{name}, one for me."
    end
  end
  extend(ClassMethods)
end


