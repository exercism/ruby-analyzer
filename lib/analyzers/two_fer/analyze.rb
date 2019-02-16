module TwoFer
  class Analyze < ExerciseAnalyzer
    include Mandate

    def analyze!
      ####
      # First we check that there is a two-fer class or module
      # and that it contains a method called two-fer
      two_fer_module = ExtractModuleOrClass.(root_node, "TwoFer")
      return fail_with_no_module unless two_fer_module

      two_fer_method = ExtractClassMethod.(two_fer_module, "two_fer")
      return fail_with_no_method unless two_fer_method

      # Set ourselves some useful helper variables
      arguments = two_fer_method.arguments
      argument = arguments[0]

      ####
      # Now we want to ensure that the method signature
      # is sane and that it has valid arguments

      # If there is no parameter or it's not called name
      # or it doesn't have a default value, then this solution
      # won't pass the tests.
      if arguments.size != 1
        return fail_with_missing_default_param
      end

      # If they provide a splat, the tests can pass but we
      # should suggest they use a real paramater
      return fail_with_splat_args(argument.children[0]) if argument.restarg_type?

      # If they don't provide an optional argument the tests will fail
      return fail_with_missing_default_param unless argument.optarg_type?

      ####
      # Now let's check for the optimal solution, which looks like this:
      #   def self.two_fer(name="you")
      #     "One for #{name}, one for me."
      #   end
      #
      #  This solution's AST looks like this:
      #  => s(:dstr,
      #       s(:str, "One for "),
      #       s(:begin,
      #         s(:lvar, :name)),
      #       s(:str, ", one for me."))

      # Firstly we want to check whether the user has set
      # the param to be "you". This is a pretty strong indication
      # that they're on the right track
      correct_default_param = argument.children[1].children[0] == "you"

      # Secondly let's check whether we have a one line solution
      one_line_solution = two_fer_method.body.line_count == 1

      # Finally, are we using string interpolation?
      using_string_interpolation = two_fer_method.body.dstr_type?

      # If we have on correct default param,
      # a one-line solution, and we're using
      # string interpolation, we can probably pass the test
      if correct_default_param &&
         one_line_solution &&
         using_string_interpolation

        # I'm not sure whether we want to integegate this all
        # the way down to check the exact AST here? Instead
        # I'm checking to see if there is the right amount of
        # things being pieced together.
        if two_fer_method.body.children.size == 3
          return approve!

        # If we have more than three things, then I've got
        # no idea what's going on so let's refer to a mentor
        # and get out of here.
        else
          return refer_to_mentor!
        end

        # Either way, we're done.
        return
      end

      # If we have a correct default param and a one-line
      # solution, but we're not using interpolation, then
      # let's check for string-building instead.
      if correct_default_param &&
         one_line_solution

        # If we've got a stack that ends in a plus then we
        # have string building so let's tell them how to use
        # interpolation instead
        if two_fer_method.body.children.size == 3 &&
           two_fer_method.body.children[1] == :+
          return fail_with_string_building

        elsif two_fer_method.body.children[0] == nil &&
           two_fer_method.body.children[1] == :format
          return fail_with_kernel_format

        elsif two_fer_method.body.children[0].type == :str &&
           two_fer_method.body.children[1] == :%
          return fail_with_string_format

        # If we have something else going on, then I've got
        # no idea what's going on so let's refer to a mentor
        # and get out of here.
        else
          return refer_to_mentor!
        end
      end

      ####
      # Now we want to test for the most common mistake
      # with is using a conditional instead of a default param
      #
      # Often people do something like the following;
      # class TwoFer
      #   def self.two_fer(name=mil)
      #     if name == nil
      #       ...
      #     else
      #       ...
      #     end

      # #####
      # TODO FROM DOWN HERE ONWARDS
      # #####

      # And secondly we want to see if they've used a conditional
      conditional = true#ExtractCondition.(two_fer_method, argument)

      # If they have a default param other than "you" and they
      # have used an if statement we can recommend with confidence
      # that they should instead use a default paramter
      if !correct_default_param && conditional
        return fail_with_incorrect_default_param
      end

      # If they have the right default param, or they've not
      # used a conditional in a way we are yet analysing it's
      # probably best to pass this straight to a mentor
      refer_to_mentor!
    end

    def fail_with_no_module
      self.messages << "No module or class called TwoFer"
      self.approve = false
    end

    def fail_with_no_method
      self.messages << "No method called two_fer"
      self.approve = false
    end

    def fail_with_splat_args(name)
      self.messages << "Rather than using *#{name}, how about acutally setting a paramater called 'name'?"
      self.approve = false
    end

    def fail_with_missing_default_param
      self.messages << "There is not a correct default param - the tests will fail"
      self.approve = false
    end

    def fail_with_incorrect_default_param
      self.messages << "You could set the default value to 'you' to avoid conditionals"
      self.approve = false
    end

    def fail_with_string_building
      self.messages << "Rather than using string building, use interpolation"
      self.approve = false
    end

    def fail_with_kernel_format
      self.messages << "Rather than using the format method, use interpolation"
      self.approve = false
    end

    def fail_with_string_format
      self.messages << "Rather than using string's format/percentage method, use interpolation"
      self.approve = false
    end

    def approve!
      self.approve = true
    end

    def refer_to_mentor!
      self.refer_to_mentor = true

      # Refering to mentor is an explicit
      # command resulting from weirdness
      # and should override approving
      self.approve = false
    end
  end
end
