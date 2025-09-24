require "test_helper"

module SA
  class ExtractModuleMethodTest < Minitest::Test
    def test_instance_method_is_not_extracted
      source = '
        class TestClass
          def good_method
          end
        end
      '
      class_ast = extract_class_from_ast(source)
      assert_nil ExtractModuleMethod.(class_ast, "good_method")
    end

    def test_correct_class_method_is_extracted
      source = '
        class TestClass
          def self.bad_method
          end

          def self.good_method
          end

          def self.naughty_method
          end
        end
      '
      class_ast = extract_class_from_ast(source)
      result = ExtractModuleMethod.(class_ast, "good_method")
      assert_equal :good_method, result.method_name
    end

    def test_correct_class_method_with_self_syntax
      source = '
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
      '
      class_ast = extract_class_from_ast(source)
      result = ExtractModuleMethod.(class_ast, "good_method")
      assert_equal :good_method, result.method_name
    end

    def test_correct_module_method_is_extracted
      source = '
        class TestModule
          def self.bad_method
          end

          def self.good_method
          end

          def self.naughty_method
          end
        end
      '
      module_ast = extract_module_from_ast(source)
      result = ExtractModuleMethod.(module_ast, "good_method")
      assert_equal :good_method, result.method_name
    end

    def test_correct_module_method_with_module_function_syntax
      source = '
        module TestModule
          module_function

          def bad_method
          end

          def good_method
          end

          def naughty_method
          end
        end
      '
      module_ast = extract_module_from_ast(source)
      result = ExtractModuleMethod.(module_ast, "good_method")
      assert_equal :good_method, result.method_name
    end

    def test_correct_module_method_with_post_module_function_syntax
      source = '
        module TestModule
          def bad_method
          end

          def good_method
          end

          def naughty_method
          end

          module_function :bad_method, :good_method, :naughty_method
        end
      '
      module_ast = extract_module_from_ast(source)
      result = ExtractModuleMethod.(module_ast, "good_method")
      assert_equal :good_method, result.method_name
    end

    def test_correct_module_method_with_hardcoded_module_name
      source = '
        module TestModule
          def TestModule.bad_method
          end

          def TestModule.good_method
          end

          def TestModule.naughty_method
          end
        end
      '
      module_ast = extract_module_from_ast(source)
      result = ExtractModuleMethod.(module_ast, "good_method")
      assert_equal :good_method, result.method_name
    end

    def test_module_method_with_incorrect_module_name
      source = '
        class TestModule
          def Wrong.good_method
          end
        end
      '
      module_ast = extract_module_from_ast(source)
      assert_nil ExtractModuleMethod.(module_ast, "good_method")
    end
  end
end
