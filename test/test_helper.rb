# This must happen above the env require below
if ENV["CAPTURE_CODE_COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

gem 'minitest'

require "minitest/autorun"
require 'minitest/pride'
require "mocha/minitest"

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp/output')
  SOLUTION_PATH = Pathname.new('/tmp')
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "analyzer"

class Minitest::Test
  def parse_ast(source)
    @parse_ast ||= begin
      buffer        = Parser::Source::Buffer.new(nil)
      buffer.source = source
      builder       = RuboCop::AST::Builder.new
      parser        = Parser::CurrentRuby.new(builder)

      parser.parse(buffer)
    end
  end

  def extract_module_from_ast(source, classname = "TestModule")
    extract_module_or_class_from_ast(source, classname)
  end

  def extract_class_from_ast(source, classname = "TestClass")
    extract_module_or_class_from_ast(source, classname)
  end

  def extract_module_or_class_from_ast(source, classname = "TestClass")
    SA::ExtractModuleOrClass.(parse_ast(source), classname)
  end

  def extract_method_from_ast(source, method_name = "foobar")
    SA::ExtractInstanceMethod.(parse_ast(source), method_name)
  end

  def s(type, *children)
    Parser::AST::Node.new(type, children)
  end
end
