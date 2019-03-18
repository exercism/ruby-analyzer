class ExerciseAnalyzer

  # This is just flow-control for quickly exiting the
  # analysis. We probably don't want to do things this
  # way eventually, but it helps remove noise for now.
  class FinishedFlowControlException < RuntimeError
  end

  def initialize(code_to_analyze)
    @code_to_analyze = code_to_analyze
    @status = nil
    @comments = []
  end

  def call
    begin
      analyze!
    rescue FinishedFlowControlException
    end
    results
  end

  def results
    {
      status: status,
      comments: comments
    }
  end

  private
  attr_reader :code_to_analyze

  protected
  attr_accessor :status, :comments

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
