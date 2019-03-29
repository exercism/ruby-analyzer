# frozen_string_literal: true

# Responsible for equally sharing an item
class TwoFer
  def self.two_fer(name = nil)
    "One for #{name.nil? ? 'you' : name}, one for me."
  end
end
