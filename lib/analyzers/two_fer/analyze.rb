module TwoFer

  MESSAGES = {
    no_module:               "ruby.general.no_target_module",
    no_method:               "ruby.general.no_target_method",
    incorrect_indentation:   "ruby.general.incorrect_indentation",
    splat_args:              "ruby.two_fer.splat_args",              #Rather than using *%s, how about actually setting a parameter called 'name'?",
    missing_default_param:   "ruby.two_fer.missing_default_param",   #"There is no correct default param - the tests will fail",
    incorrect_default_param: "ruby.two_fer.incorrect_default_param", #You could set the default value to 'you' to avoid conditionals",
    string_building:         "ruby.two_fer.avoid_string_building",   # "Rather than using string building, use interpolation",
    kernel_format:           "ruby.two_fer.avoid_kernel_format",     #"Rather than using the format method, use interpolation",
    string_format:           "ruby.two_fer.avoid_string_format",     #"Rather than using string's format/percentage method, use interpolation"
  }

  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
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
      disapprove!(:no_module) unless target_module
      disapprove!(:no_method) unless target_method
    end

    def check_method_signature!
      # If there is no parameter or it doesn't have a default value,
      # then this solution won't pass the tests.
      disapprove!(:missing_default_param) if parameters.size != 1

      # If they provide a splat, the tests can pass but we
      # should suggest they use a real parameter
      disapprove!(:splat_args, first_parameter_name) if first_parameter.restarg_type?

      # If they don't provide an optional argument the tests will fail
      disapprove!(:missing_default_param) unless first_parameter.optarg_type?
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

      return unless default_argument_is_optimal?
      return unless one_line_solution?
      return unless using_string_interpolation?

      # If the interpolation has more than three components, then they've
      # done something weird, so let's get a mentor to look at it!
      refer_to_mentor! unless string_interpolation_has_three_components?

      approve_if_whitespace_is_sensible!
    end

    def check_for_correct_solution_without_string_interpolaton!
      # If we don't have a correct default argument or a one line
      # solution then let's just get out of here.
      return unless default_argument_is_optimal?
      return unless one_line_solution?

      loc = SA::Helpers.extract_first_line_from_method(target_method)

      # In the case of:
      # "One for " + name + ", one for me."
      if loc.method_name == :+ &&
         loc.arguments[0].type == :str
        approve_if_whitespace_is_sensible!(:string_building)
      end

      # In the case of:
      # format("One for %s, one for me.", name)
      if loc.method_name == :format &&
         loc.receiver == nil &&
         loc.arguments[0].type == :str &&
         loc.arguments[1].type == :lvar
        approve_if_whitespace_is_sensible!(:kernel_format)
      end

      # In the case of:
      # "One for %s, one for me." % name
      if loc.method_name == :% &&
         loc.receiver.type == :str &&
         loc.arguments[0].type == :lvar
        approve_if_whitespace_is_sensible!(:string_format)
      end

      # If we have a one-line method that passes the tests, then it's not
      # something we've planned for, so let's refer it to a mentor
      return refer_to_mentor!
    end

    def check_for_conditional_on_default_argument!
      loc = SA::Helpers.extract_first_line_from_method(target_method)

      # If we don't have a conditional, then let's get out of here.
      #
      # TODO: We might want to refactor this to extract a conditional from the
      # method rather than insist on it being the first line.
      return unless loc.type == :if

      # Get the clause of the conditional (i.e. the bit after the "if" keyword)
      conditional = SA::Helpers.extract_conditional_clause(loc)

      # Let's warn about using a better default if they `if name == nil`
      if SA::Helpers.lvar?(conditional.receiver, :name) &&
         conditional.first_argument == default_argument
        disapprove!(:incorrect_default_param)
      end

      # Same thing but if they do it the other way round, i.e. `if nil == name`
      if conditional.receiver == default_argument &&
         SA::Helpers.lvar?(conditional.first_argument, :name)
        disapprove!(:incorrect_default_param)
      end
    end

    # ###
    # Analysis helpers
    # ###
    def default_argument_is_optimal?
      default_argument_value == "you"
    end

    def one_line_solution?
      target_method.body.line_count == 1
    end

    def using_string_interpolation?
      target_method.body.dstr_type?
    end

    def string_interpolation_has_three_components?
      #target_method.body.pry
      target_method.body.children.size == 3
    end

    # REFACTOR: This could be refactored to strip blank
    # lines and then use each_cons(2).
    def indentation_is_sensible?
      previous_line = nil
      code_to_analyze.lines.each do |line|
        # If the previous line or this line is
        # just a whitespace line, don't consider it
        # when checking for indentation
        unless previous_line == nil ||
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

    memoize
    def target_module
      SA::Helpers.extract_module_or_class(root_node, "TwoFer")
    end

    memoize
    def target_method
      SA::Helpers.extract_module_method(target_module, "two_fer")
    end

    memoize
    def parameters
      target_method.arguments
    end

    memoize
    def first_parameter
      parameters.first
    end

    def first_parameter_name
      first_parameter.children[0]
    end

    def default_argument
      first_parameter.children[1]
    end

    def default_argument_value
      default_argument.children[0]
    end

    # ###
    # Flow helpers
    #
    # These are totally generic to all exercises and
    # can probably be extracted to parent
    # ###
    def approve_if_whitespace_is_sensible!(msg = nil)
      if indentation_is_sensible?
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
