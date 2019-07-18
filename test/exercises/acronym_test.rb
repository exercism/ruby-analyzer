require "test_helper"
require 'pry'

class AcronymTest < Minitest::Test
  def test_method_chaining_passes
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end

  def test_scan_with_any_regex_passes
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.scan(/any/).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end

  def test_split_with_any_regex_passes
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.split(/[ -]/).map(&:chr).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end
end
