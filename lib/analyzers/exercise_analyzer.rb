class ExerciseAnalyzer
  def initialize(code_to_analyze)
    @code_to_analyze = code_to_analyze
    @approve = false
    @refer_to_mentor = false
    @messages = []
  end

  def call
    analyze!
    results
  end


  def results
    {
      approve: approve,
      refer_to_mentor: refer_to_mentor,
      messages: messages
    }
  end

  private
  attr_reader :code_to_analyze

  protected
  attr_accessor :approve, :refer_to_mentor, :messages

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
