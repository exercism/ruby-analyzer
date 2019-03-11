require "test_helper"
require 'pry'

class ExtractClassMethodTest < Minitest::Test
  def test_correct_method_is_extracted
    source = %q{
      class TestClass
        def self.bad_method
        end

        def self.good_method
        end

        def self.naughty_method
        end
      end
    }
    class_ast = extract_class_from_ast(source)
    result = ExtractClassMethod.(class_ast, "good_method")
    assert_equal :good_method, result.method_name
  end

  def test_correct_method_with_alternative_syntax
    source = %q{
      class TestClass
        class << self
          def bad_method
          end

          def good_method
          end

          def naughty_method
          end
        end
      end
    }
    class_ast = extract_class_from_ast(source)
    result = ExtractClassMethod.(class_ast, "good_method")
    assert_equal :good_method, result.method_name
  end
end
