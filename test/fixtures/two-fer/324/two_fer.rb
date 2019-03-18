class TwoFer
  def self.two_fer(name='')
    if name === ''
      "One for you, one for me."
    elsif name == 'Alice'
      "One for #{name}, one for me."
    elsif name != 'Alice'
      "One for #{name}, one for me."
    end
  end
end

# double quotes
