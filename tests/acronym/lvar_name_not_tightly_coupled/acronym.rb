class Acronym
  def self.abbreviate(sentence)
    sentence.tr('-', ' ').split.map(&:chr).join.upcase
  end
end
