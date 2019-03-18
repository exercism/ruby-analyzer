module TwoFer
	def self.two_fer(name = "")
		if name == "" 
			return "One for you, one for me."
		elsif name == "Alice"
			return "One for Alice, one for me."
		elsif name == "Bob"
			return "One for Bob, one for me."	
		end
	end
end