class SolutionRepresentation
  include Mandate
  include SA::InlineHelpers

  def initialize(code_to_analyze)
    @code_to_analyze = code_to_analyze
  end

  # REFACTOR: This could be refactored to strip blank
  # lines and then use each_cons(2).
  def indentation_is_sensible?
    previous_line = nil
    code_to_analyze.lines.each do |line|
      # If the previous line or this line is
      # just a whitespace line, don't consider it
      # when checking for indentation
      unless previous_line.nil? ||
             previous_line =~ /^\s*\n*$/ ||
             line =~ /^\s*\n*$/

        previous_line_lspace = previous_line[/^ */].size
        line_lspace = line[/^ */].size

        return false if (previous_line_lspace - line_lspace).abs > 2
      end

      previous_line = line
    end

    true
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
