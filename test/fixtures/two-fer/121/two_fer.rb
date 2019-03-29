class TwoFer

	def self.two_fer(name = '')
		if name == ''
			puts = "One for you, one for me."
		else
			puts = "One for " + name + ", one for me."
		end
	end

end

TwoFer.two_fer