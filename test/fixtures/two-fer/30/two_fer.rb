module TwoFer
	def self.two_fer(params='')
		if params != ''
			return "One for #{params}, one for me."
		else 
			return "One for you, one for me."
		end
	end
end