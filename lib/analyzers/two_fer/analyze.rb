module TwoFer

  MESSAGES = {
    no_module:               "ruby.general.no_target_module",
    no_method:               "ruby.general.no_target_method",
    incorrect_indentation:   "ruby.general.incorrect_indentation",
    explicit_return:         "ruby.general.explicit_return",         # "The last line automatically gets returned"
    splat_args:              "ruby.two-fer.splat_args",              # "Rather than using *%s, how about actually setting a parameter called 'name'?"
    missing_default_param:   "ruby.two-fer.missing_default_param",   # "There is no correct default param - the tests will fail"
    incorrect_default_param: "ruby.two-fer.incorrect_default_param", # "You could set the default value to 'you' to avoid conditionals"
    reassigning_param:       "ruby.two-fer.reassigning_param",       # "You don't need to reassign - use the default param"
    string_interpolation:    "ruby.two-fer.string_interpolation",    # "String interpolation is a good way to build strings, here are some other options to explore"
    string_concatenation:    "ruby.two-fer.string_concatenation",    # "Rather than using string building, use interpolation"
    kernel_format:           "ruby.two-fer.kernel_format",           # "Rather than using the format method, use interpolation"
    string_format:           "ruby.two-fer.string_format",           # "Rather than using string's format/percentage method, use interpolation"
  }

  class Analyze < ExerciseAnalyzer
    include Mandate

    # Note that all "check_...!" methods exit this method if the solution
    # is approved or disapproved, so each step is only called if the
    # previous one has not resolved what to do.

    def analyze!
      #target_method.pry
      check_structure!
      check_method_signature!
      check_for_single_line_solution!
      check_for_conditional_on_default_argument!
      check_for_reassigned_parameter!
      # check_for_names!

      # We don't have any idea about this solution, so let's refer it to a
      # mentor and get exit our analysis.
      refer_to_mentor!
    end

    # ###
    # Analysis functions
    # ###

    # Firstly we want to check that the structure of this
    # solution is correct and that there is nothing structural
    # stopping it from passing the tests
    def check_structure!
      disapprove!(:no_module) unless solution.has_target_module?
      disapprove!(:no_method) unless solution.has_target_method?
    end

    # Then we we want to ensure that the method signature
    # is sane and that it has valid arguments
    def check_method_signature!
      disapprove!(:missing_default_param) unless solution.has_one_parameter?
      disapprove!(:splat_args, {name_variable: solution.first_parameter_name}) if solution.uses_splat_args?
      disapprove!(:missing_default_param) unless solution.first_paramater_has_default_value?
    end

    # There is one optimal solution for two-fer which needs
    # no comments and can just be approved. If we have it, then
    # let's just acknowledge it and get out of here. We also often see
    # solutions that are correct but use different # string concatenation
    # options (e.g. string#+, String.format, etc). We'll approve these but
    # want to leave a comment that introduces them to string interpolation
    # in case they don't know about it.
    # The optional solution looks like this:
    #
    # def self.two_fer(name="you")
    #   "One for #{name}, one for me."
    # end
    # 
    # The default argument must be 'you', and it must just be a single
    # statement using interpolation. Other solutions might be approved
    # but this is the only one that we would approve without comment.
    def check_for_single_line_solution!
      return unless solution.default_argument_is_optimal?
      return unless solution.one_line_solution?

      if solution.uses_string_interpolation?
        if solution.string_interpolation_is_correct?
          approve_if_implicit_return!(:string_interpolation, {name_variable: solution.first_parameter_name})
        else
          refer_to_mentor!
        end
      end

      # "One for " + name + ", one for me."
      approve_if_implicit_return!(:string_concatenation, {name_variable: solution.first_parameter_name}) if solution.uses_string_concatenation?

      # format("One for %s, one for me.", name)
      approve_if_implicit_return!(:kernel_format, {name_variable: solution.first_parameter_name}) if solution.uses_kernel_format?

      # "One for %s, one for me." % name
      approve_if_implicit_return!(:string_format, {name_variable: solution.first_parameter_name}) if solution.uses_string_format?

      # If we have a one-line method that passes the tests, then it's not
      # something we've planned for, so let's refer it to a mentor
      return refer_to_mentor!
    end

    # The most common error in twofer is people using conditionals
    # to check where the value passed in is nil, rather than using a default
    # value. We want to check for conditionals and tell the user about the
    # default parameter if we see one.
    def check_for_conditional_on_default_argument!
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

    # Sometimes, rather than setting a variable, people reassign the input param e.g.
    #   name ||= "you"
    def check_for_reassigned_parameter!
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

    # Sometimes people specify the names (if name == "Alice" ...). If we
    # do this, suggest using string interpolation to make us of the
    # parameter, rather than using a conditional on it.
    def check_for_names!
    end

    # ###
    # Flow helpers
    #
    # These are totally generic to all exercises and
    # can probably be extracted to parent
    # ###

    def approve_if_implicit_return!(msg = nil, params = {})
      # If we're got a correct solution but they've given an explicit
      # return then let's warn them against that.
      disapprove!(:explicit_return) if solution.has_explicit_return?

      approve_if_whitespace_is_sensible!(msg, params)
    end

    def approve_if_whitespace_is_sensible!(msg = nil, params = {})
      if solution.indentation_is_sensible?
        self.comments << {comment: MESSAGES[msg], params: params} if msg
        self.status = :approve

        raise FinishedFlowControlException

      else
        disapprove!(:incorrect_indentation)
      end
    end

    def refer_to_mentor!
      self.status = :refer_to_mentor

      raise FinishedFlowControlException
    end

    def disapprove!(msg, params = {})
      self.status = :disapprove
      if params.length > 0
        self.comments << {comment: MESSAGES[msg], params: params}
      else
        self.comments << MESSAGES[msg]
      end

      raise FinishedFlowControlException
    end
  end
end
