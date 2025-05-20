class SolutionRepresentation
  include Mandate
  include SA::InlineHelpers

  def initialize(code_to_analyze)
    @code_to_analyze = code_to_analyze
  end

  def indentation_is_sensible?
    code_to_analyze.lines.reject { |line| line =~ /^\s*\n*$/ }.each_cons(2).all? do |lines|
      line_1_space = lines.first[/^ */].size
      line_2_space = lines.last[/^ */].size

      [0, 2].include? (line_2_space - line_1_space).abs
    end
  end

  def has_target_module?
    target_module
  end

  def has_target_method?
    target_method
  end

  # MOVE BELOW HERE TO PRIVATE

  memoize
  def target_method
    SA::Helpers.extract_module_method(target_module, "two_fer")
  end

  private
  attr_reader :code_to_analyze

  memoize
  def target_module
    SA::Helpers.extract_module_or_class(root_node, "TwoFer")
  end

  def default_argument_value
    default_argument.children[0]
  end

  def root_node
    @root_node ||= begin
      buffer        = Parser::Source::Buffer.new(nil)
      buffer.source = code_to_analyze
      builder       = RuboCop::AST::Builder.new
      parser        = Parser::CurrentRuby.new(builder)

      parser.parse(buffer)
    end
  end
end
