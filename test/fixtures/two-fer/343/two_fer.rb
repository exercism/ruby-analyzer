class TwoFer
	def self.two_fer(name = "w")
		if name.to_s.chomp == "Alice"
			a = "One for Alice, one for me."
			a.force_encoding("UTF-8")
			puts a
			return a
		elsif name.to_s.chomp == "Bob"
			y = "One for Bob, one for me."
			y.force_encoding("UTF-8")
			puts y
			return y
		else 
			x = "One for you, one for me."
			x.force_encoding("UTF-8")
			puts x
			return x
		end
	end
end

TwoFer.two_fer
