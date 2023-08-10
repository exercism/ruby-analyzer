module Acronym
  def self.abbreviate(words)
    words.tr('-', ' ').split.map(&:chr).join.upcase
  end
end
