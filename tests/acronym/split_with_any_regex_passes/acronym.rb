class Acronym
  def self.abbreviate(words)
    words.split(/[ -]/).map(&:chr).join.upcase
  end
end
