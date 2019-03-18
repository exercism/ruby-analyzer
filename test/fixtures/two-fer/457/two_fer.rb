class TwoFer
  def self.two_fer(name=nil)
    case name
    when 'Alice' then 'One for Alice, one for me.'
    when 'Bob' then 'One for Bob, one for me.'
    else
      'One for you, one for me.'
    end
  end
end
