require "test_helper"

class AcronymTest < AnalyzerTest
  def setup
    @exercise_slug = "acronym"
  end

  def test_method_chaining_passes
    source = "
      class Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    "
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end

  def test_lvar_name_not_tightly_coupled
    source = "
      class Acronym
        def self.abbreviate(sentence)
          sentence.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    "
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end

  def test_method_chaining_with_block_syntax_passes_with_comment
    source = "
      class Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map { |word| word.chr }.join.upcase
        end
      end
    "
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_equal ["ruby.acronym.block_syntax.shorthand"], results["comments"]
  end

  def test_method_chaining_with_block_syntax_with_arbitrary_arg_passes
    source = "
      class Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map { |term| term.chr }.join.upcase
        end
      end
    "
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_equal ["ruby.acronym.block_syntax.shorthand"], results["comments"]
  end

  def test_module_method_passes
    source = "
      module Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    "
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end

  def test_refers_to_mentor_with_method_not_matching
    source = "
      class Acronym
        def self.abbreviate(words)
          test.words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    "
    results = analysis_results(source)
    assert_equal "refer_to_mentor", results["status"]
  end

  def test_refers_to_mentor_with_random_method_body
    source = '
      class Acronym
        def self.abbreviate(words)
          anything_here.123.456.test_method
        end
      end
    '
    results = analysis_results(source)
    assert_equal "refer_to_mentor", results["status"]
  end

  def test_scan_with_any_regex_passes
    source = '
      class Acronym
        def self.abbreviate(words)
          words.scan(/any/).join.upcase
        end
      end
    '
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end

  def test_split_with_any_regex_passes
    source = '
      class Acronym
        def self.abbreviate(words)
          words.split(/[ -]/).map(&:chr).join.upcase
        end
      end
    '
    results = analysis_results(source)
    assert_equal "approve", results["status"]
    assert_empty results["comments"]
  end
end
