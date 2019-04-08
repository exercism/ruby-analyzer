class ExerciseAnalyzer

  # This is just flow-control for quickly exiting the
  # analysis. We probably don't want to do things this
  # way eventually, but it helps remove noise for now.
  class FinishedFlowControlException < RuntimeError
  end

  def initialize(code_to_analyze)
    @status = nil
    @comments = []

    solution_class = "#{self.class.name.split("::").first}::Representation".constantize
    @solution = solution_class.new(code_to_analyze)
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
  attr_reader :solution

  protected
  attr_accessor :status, :comments
end
