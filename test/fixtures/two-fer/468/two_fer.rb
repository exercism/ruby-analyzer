module TwoFer
  module_function
  def two_fer(other = "you")
    format("One for %<other>s, one for me.", other: other)
  end
end
