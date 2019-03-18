class TwoFer
  def self.two_fer(name = nil)
    "One for #{get_name(name)}, one for me."
  end

  private
    def self.get_name(name)
      name.nil? ? "you" : name
    end
end