class TwoFer
  def self.two_fer(aName = '')
    if aName.empty?
      return 'One for you, one for me.'
    else
      return 'One for ' + aName.capitalize + ', one for me.'
    end
  end
end
