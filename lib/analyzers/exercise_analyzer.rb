class ExerciseAnalyzer
  # This is just flow-control for quickly exiting the
  # analysis. We probably don't want to do things this
  # way eventually, but it helps remove noise for now.
  class FinishedFlowControlException < RuntimeError
  end

  def initialize(code_to_analyze)
    @status = nil
    @comments = []

    solution_class = "#{self.class.name.split('::').first}::Representation".constantize
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
      status:,
      comments:
    }
  end

  def approve_if_whitespace_is_sensible(msg = nil, params = {})
    if solution.indentation_is_sensible?
      self.comments << if params.any?
                         { comment: msg, params: }
                       else
                         msg
                       end
      self.status = :approve

      raise FinishedFlowControlException
    else
      disapprove("ruby.general.incorrect_indentation")
    end
  end

  def disapprove(msg, params = {})
    self.status = :disapprove
    self.comments << if params.any?
                       { comment: msg, params: }
                     else
                       msg
                     end

    raise FinishedFlowControlException
  end

  def refer_to_mentor
    self.status = :refer_to_mentor

    raise FinishedFlowControlException
  end

  private
  attr_reader :solution

  protected
  attr_accessor :status, :comments
end
