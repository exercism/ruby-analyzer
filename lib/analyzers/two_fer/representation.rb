module TwoFer
  class Representation < SolutionRepresentation
    def first_paramater_has_default_value?
      first_parameter.optarg_type?
    end

    def uses_splat_args?
      first_parameter.restarg_type?
    end

    def one_line_solution?
      target_method.body.line_count == 1
    end

    def default_argument_is_optimal?
      default_argument_value == "you"
    end

    def has_one_parameter?
      parameters.size == 1
    end

    def has_explicit_return?
      target_method.children.last.return_type?
    end

    def uses_string_interpolation?
      single_line_body.dstr_type?
    end

    def string_interpolation_is_correct?
      loc = single_line_body

      loc.children[0] == s(:str, "One for ") &&
      loc.children[1] == s(:begin, s(:lvar, first_parameter_name)) &&
      loc.children[2] == s(:str, ", one for me.")
    end

    # "One for " + name + ", one for me."
    def uses_string_building?
      loc = single_line_body

      loc.method_name == :+ &&
      loc.arguments[0].type == :str
    end

    # format("One for %s, one for me.", name)
    def uses_kernel_format?
      loc = single_line_body

      loc.method_name == :format &&
      loc.receiver == nil &&
      loc.arguments[0].type == :str &&
      loc.arguments[1].type == :lvar
    end

    # "One for %s, one for me." % name
    def uses_string_format?
      loc = single_line_body

      loc.method_name == :% &&
      loc.receiver.type == :str &&
      loc.arguments[0].type == :lvar
    end

    def has_any_if_statements?
      if_statements.size > 0
    end

    def has_single_if_statement?
      if_statements.size == 1
    end

    def uses_default_param_in_if_statement?
      if_statement = if_statements.first
      conditional = SA::Helpers.extract_conditional_clause(if_statement)

      # if name
      return true if SA::Helpers.lvar?(conditional, first_parameter_name)

      # if name.nil?
      return true if conditional.send_type? &&
                     SA::Helpers.lvar?(conditional.receiver, first_parameter_name)

      # if name == "nil"
      return true if SA::Helpers.lvar?(conditional.receiver, first_parameter_name) &&
                     conditional.first_argument == default_argument

      # if nil == name
      return true if SA::Helpers.lvar?(conditional.first_argument, first_parameter_name) &&
                     conditional.receiver == default_argument


      return false
    end

    def reassigns_parameter?
      or_asgn_statements.size > 0
    end

    def reassigns_parameter_multiple_times?
      or_asgn_statements.size > 1
    end

    def reassigns_parameter_to_you?
      assignment = or_asgn_statements.first

      assignment.children[0] == s(:lvasgn, first_parameter_name) &&
      assignment.children[1] == s(:str, "you")
    end

    private
    memoize
    def parameters
      target_method.arguments
    end

    memoize
    def default_argument
      first_parameter.children[1]
    end

    memoize
    def first_parameter
      parameters.first
    end

    memoize
    def first_parameter_name
      first_parameter.children[0]
    end

    memoize
    def single_line_body
      if target_method.body.return_type?
        target_method.body.children.first
      else #if target_method.body.dstr_type?
        target_method.body
      end
    end

    memoize
    def if_statements
      SA::Helpers.extract_nodes(:if, target_method)
    end

    memoize
    def or_asgn_statements
      SA::Helpers.extract_nodes(:or_asgn, target_method)
    end
  end
end

