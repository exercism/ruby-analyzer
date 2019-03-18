module TwoFer
	def self.two_fer(str = 'you')
		if(str == 'you')
			"One for you, one for me."
		else
			"One for #{str}, one for me."
		end
	end
end