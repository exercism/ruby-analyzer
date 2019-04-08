module TwoFer

  MESSAGES = {
    no_module:               "ruby.general.no_target_module",
    no_method:               "ruby.general.no_target_method",
    incorrect_indentation:   "ruby.general.incorrect_indentation",
    explicit_return:         "ruby.general.explicit_return",         #"The last line automatically gets returned"
    splat_args:              "ruby.two_fer.splat_args",              #Rather than using *%s, how about actually setting a parameter called 'name'?",
    missing_default_param:   "ruby.two_fer.missing_default_param",   #"There is no correct default param - the tests will fail",
    incorrect_default_param: "ruby.two_fer.incorrect_default_param", #You could set the default value to 'you' to avoid conditionals",
    reassigning_param:       "ruby.two_fer.reassigning_param",    # You don't need to reassign - use the default param
    string_building:         "ruby.two_fer.avoid_string_building",   # "Rather than using string building, use interpolation",
    kernel_format:           "ruby.two_fer.avoid_kernel_format",     #"Rather than using the format method, use interpolation",
    string_format:           "ruby.two_fer.avoid_string_format",     #"Rather than using string's format/percentage method, use interpolation"
  }

  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      #target_method.pry

      # Note that all "check_...!" methods exit this method if the solution
      # is approved or disapproved, so each step is only called if the
      # previous one has not resolved what to do.

      # Firstly we want to check that the structure of this
      # solution is correct and that there is nothing structural
      # stopping it from passing the tests
      check_structure!

      # Now we want to ensure that the method signature
      # is sane and that it has valid arguments
      check_method_signature!

      # There is one optimal solution for two-fer which needs
      # no comments and can just be approved. If we have it, then
      # let's just acknowledge it and get out of here.
      check_for_optimal_solution!

      # We often see solutions that are correct but use different
      # string concatenation options (e.g. string#+, String.format, etc)
      # We'll approve these but want to leave a comment that introduces
      # them to string interpolation in case they don't know about it.
      check_for_correct_solution_without_string_interpolaton!

      # The most common error in twofer is people using conditionals
      # to check where the value passed in is nil, rather than using a default
      # value. We want to check for conditionals and tell the user about the
      # default parameter if we see one.
      check_for_conditional_on_default_argument!

      # Sometimes, rather than setting a variable, people reassign the input param e.g.
      #   name ||= "you"
      check_for_reassigned_parameter!

      # Sometimes people specify the names (if name == "Alice" ...). If we
      # do this, suggest using string interpolation to make us of the
      # parameter, rather than using a conditional on it.
      # check_for_names!

      # We don't have any idea about this solution, so let's refer it to a
      # mentor and get exit our analysis.
      refer_to_mentor!
    end

    # ###
    # Analysis functions
    # ###
    def check_structure!
      # First we check that there is a two-fer class or module
      # and that it contains a method called two-fer
      disapprove!(:no_module) unless solution.has_target_module?
      disapprove!(:no_method) unless solution.has_target_method?
    end

    def check_method_signature!
      # If there is no parameter or it doesn't have a default value,
      # then this solution won't pass the tests.
      disapprove!(:missing_default_param) unless solution.has_one_parameter?

      # If they provide a splat, the tests can pass but we
      # should suggest they use a real parameter
      disapprove!(:splat_args, solution.first_parameter_name) if solution.uses_splat_args?

      # If they don't provide an optional argument the tests will fail
      disapprove!(:missing_default_param) unless solution.first_paramater_has_default_value?
    end

    def check_for_optimal_solution!
      # The optional solution looks like this:
      #
      # def self.two_fer(name="you")
      #   "One for #{name}, one for me."
      # end
      # 
      # The default argument must be 'you', and it must just be a single
      # statement using interpolation. Other solutions might be approved
      # but this is the only one that we would approve without comment.

      return unless solution.default_argument_is_optimal?
      return unless solution.one_line_solution?
      return unless solution.uses_string_interpolation?

      # If the interpolation does not follow this pattern then the student has
      # done something weird, so let's get a mentor to look at it
      refer_to_mentor! unless solution.string_interpolation_is_correct?

      approve_if_implicit_return!
    end

    def check_for_correct_solution_without_string_interpolaton!
      # If we don't have a correct default argument or a one line
      # solution then let's just get out of here.
      return unless solution.default_argument_is_optimal?
      return unless solution.one_line_solution?

      # In the case of:
      # "One for " + name + ", one for me."
      approve_if_implicit_return!(:string_building) if solution.uses_string_building?

      # In the case of:
      # format("One for %s, one for me.", name)
      approve_if_implicit_return!(:kernel_format) if solution.uses_kernel_format?

      # In the case of:
      # "One for %s, one for me." % name
      approve_if_implicit_return!(:string_format) if solution.uses_string_format?

      # If we have a one-line method that passes the tests, then it's not
      # something we've planned for, so let's refer it to a mentor
      return refer_to_mentor!
    end

    def check_for_conditional_on_default_argument!
      # If there are no if statements then we can safely get out of here.
      return unless solution.has_any_if_statements?

      # If there is more than one statement, then let's refer this to a mentor
      refer_to_mentor! unless solution.has_single_if_statement?

      # If the person checks the default paramter, then we can always tell them
      # just to set this to a more sensible value (ie "you")
      disapprove!(:incorrect_default_param) if solution.uses_default_param_in_if_statement?

      # If we have an if without that does not do an expected comparison,
      # let's refer this to a mentor and get out of here!
      refer_to_mentor!
    end

    def check_for_reassigned_parameter!
      # If there are no reassignments then we can safely get out of here.
      return unless solution.reassigns_parameter?

      # If there is more than one statement, then let's refer this to a mentor
      refer_to_mentor! if solution.reassigns_parameter_multiple_times?

      # If the solution reassigns the input paramater to "you" then we can warn
      # about reassigning the parameter and get out of here
      disapprove!(:reassigning_param) if solution.reassigns_parameter_to_you?

      # If we have a reassignment that doesn't conform to this
      # let's refer this to a mentor and get out of here!
      refer_to_mentor!
    end

    # ###
    # Flow helpers
    #
    # These are totally generic to all exercises and
    # can probably be extracted to parent
    # ###

    def approve_if_implicit_return!(msg = nil)
      # If we're got a correct solution but they've given an explicit
      # return then let's warn them against that.
      disapprove!(:explicit_return) if solution.has_explicit_return?

      approve_if_whitespace_is_sensible!(msg)
    end

    def approve_if_whitespace_is_sensible!(msg = nil)
      if solution.indentation_is_sensible?
        if msg
          self.status = :approve_with_comment
          self.comments << MESSAGES[msg]
        else
          self.status = :approve_as_optimal
        end
        raise FinishedFlowControlException

      else
        disapprove!(:incorrect_indentation)
      end
    end

    def refer_to_mentor!
      self.status = :refer_to_mentor

      raise FinishedFlowControlException
    end

    def disapprove!(msg, *msg_args)
      self.status = :disapprove_with_comment
      if msg_args.length > 0
        self.comments << [MESSAGES[msg], *msg_args]
      else
        self.comments << MESSAGES[msg]
      end

      raise FinishedFlowControlException
    end
  end
end
