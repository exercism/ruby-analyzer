class Acronym
  def self.abbreviate(words)
    test.words.tr('-', ' ').split.map(&:chr).join.upcase
  end
end
