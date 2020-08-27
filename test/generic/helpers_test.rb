require "test_helper"
require 'pry'

module SA
  class HelpersTest < Minitest::Test
    def test_extract_module_or_class_proxies_correctly
      param_1 = mock
      param_2 = mock
      output = mock

      ExtractModuleOrClass.expects(:call).with(param_1, param_2).returns(output)
      assert_equal output, Helpers.extract_module_or_class(param_1, param_2)
    end

    def text_extract_class_method_proxies_correctly
      param_1 = mock
      param_2 = mock
      output = mock

      ExtractClassMethod.expects(:call).with(param_1, param_2).returns(output)
      assert_equal output, Helpers.extract_class_method(param_1, param_2)
    end

    def test_extract_first_line_from_method_works_with_single_line_method
      source = '
        def foobar
          puts("foobar")
        end
      '
      method_ast = extract_method_from_ast(source)
      expected = s(:send, nil, :puts, s(:str, "foobar"))
      actual = Helpers.extract_first_line_from_method(method_ast)
      assert_equal expected, actual
    end

    def test_extract_first_line_from_method_works_with_multi_line_method
      source = '
        def foobar
          puts("foobar")
          puts("barfoo")
        end
      '
      method_ast = extract_method_from_ast(source)
      expected = s(:send, nil, :puts, s(:str, "foobar"))
      actual = Helpers.extract_first_line_from_method(method_ast)
      assert_equal expected, actual
    end

    def test_num_lines_in_method_works_with_single_line_method
      source = '
        def foobar
          puts("foobar")
        end
      '
      method_ast = extract_method_from_ast(source)
      assert_equal 1, Helpers.num_lines_in_method(method_ast)
    end

    def test_num_lines_in_method_works_with_single_muliline_method
      source = '
        def foobar
          puts("foobar")
          puts("barfoo")
        end
      '
      method_ast = extract_method_from_ast(source)
      assert_equal 2, Helpers.num_lines_in_method(method_ast)
    end

    def test_num_lines_in_method_works_with_single_line_split
      source = '
        def foobar
          puts "foobar" +
               "barfoo"
        end
      '
      method_ast = extract_method_from_ast(source)
      assert_equal 1, Helpers.num_lines_in_method(method_ast)
    end

    def test_lvar_fails_without_lvar
      skip
    end

    def test_lvar_fails_with_incorrectly_named_lvar
      skip
    end

    def test_lvar_succeeds_with_correct_lvar
      skip
    end

    def test_extract_conditional_clause_returns_correct_clause
      skip
    end
  end
end
