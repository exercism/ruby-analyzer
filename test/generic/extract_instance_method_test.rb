require "test_helper"

module SA
  class ExtractInstanceMethodTest < Minitest::Test
    def test_correct_method_is_extracted
      source = '
        class TestClass
          def bad_method
          end

          def good_method
          end

          def naughty_method
          end
        end
      '
      class_ast = extract_class_from_ast(source)
      result = ExtractInstanceMethod.(class_ast, "good_method")
      assert_equal :good_method, result.method_name
    end
  end
end
