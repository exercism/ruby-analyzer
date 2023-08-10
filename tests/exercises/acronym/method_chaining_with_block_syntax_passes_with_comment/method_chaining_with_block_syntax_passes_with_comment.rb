class Acronym
  def self.abbreviate(words)
    words.tr('-', ' ').split.map { |word| word.chr }.join.upcase
  end
end
