module TwoFer

	def self.two_fer(*args)
		case args.size
		when 1
			"One for #{args[0]}, one for me."
		else
			"One for you, one for me."
		end
	end
end