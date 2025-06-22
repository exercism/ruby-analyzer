require "test_helper"

module SA
  class ExtractModuleOrClassTest < Minitest::Test
    def test_correct_class_is_extracted
      source = '
        class BadClass
        end
        class GoodClass
        end
        class NaughtyClass
        end
      '
      result = ExtractModuleOrClass.(parse_ast(source), "GoodClass")
      assert_equal "GoodClass", result.children.first.const_name
    end

    def test_correct_module_is_extracted
      source = '
        module BadModule
        end
        module GoodModule
        end
        module NaughtyModule
        end
      '
      result = ExtractModuleOrClass.(parse_ast(source), "GoodModule")
      assert_equal "GoodModule", result.children.first.const_name
    end
  end
end
