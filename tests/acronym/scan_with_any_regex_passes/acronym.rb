class Acronym
  def self.abbreviate(words)
    words.scan(/any/).join.upcase
  end
end
