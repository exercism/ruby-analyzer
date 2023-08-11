class Acronym
  def self.abbreviate(words)
    words.tr('-', ' ').split.map { |term| term.chr }.join.upcase
  end
end
