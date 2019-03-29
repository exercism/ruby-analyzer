class TwoFer
	class << self 
		def two_fer(name=nil)
			return "One for you, one for me." if name.nil? || name == ""
			return "One for " + name + ", one for me." if name != ""
		end
	end
end