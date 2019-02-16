require "test_helper"
require 'pry'

class HelloCollectorTest < Minitest::Test
  # ###
  # Test the module/class
  # ###
  def test_simple_class_passes
    #skip
    source = %q{
      class TwoFer
        def self.two_fer(name="you")
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    assert results[:approve]
    assert_equal [], results[:messages]
  end

  def test_simple_module_passes
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name="you")
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    assert results[:approve]
    assert_equal [], results[:messages]
  end

  def test_simple_module_with_bookkeeping_passes
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name="you")
          "One for #{name}, one for me."
        end
      end

      module Bookkeeping
        VERSION = 10
      end
    }
    results = TwoFer::Analyze.(source)
    assert results[:approve]
    assert_equal [], results[:messages]
  end

  def test_different_module_name_fails
    #skip
    source = %q{
      module SomethingElse
        def self.two_fer(name="you")
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["No module or class called TwoFer"], results[:messages]
  end

  # ###
  # Test the method exists and is correctly structured
  # ###

  def test_different_method_value_fails
    #skip
    source = %q{
      module TwoFer
        def self.foobar(name="you")
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["No method called two_fer"], results[:messages]
  end

  def test_missing_param
    #skip
    source = %q{
      module TwoFer
        def self.two_fer
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["There is not a correct default param - the tests will fail"], results[:messages]
  end

  def test_missing_default_value_fails
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name)
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["There is not a correct default param - the tests will fail"], results[:messages]
  end

  def test_splat_fails
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(*foos)
          "One for #{name}, one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["Rather than using *foos, how about acutally setting a paramater called 'name'?"], results[:messages]
  end

  # ### 
  # Now let's guard against string building
  # ###
  def test_for_string_building
    #skip
    source = %q{
      class TwoFer
        def self.two_fer(name="you")
          "One for " + name + ", one for me."
        end
      end
    }
    results = TwoFer::Analyze.(source)
    assert results[:approve]
    assert_equal ["Rather than using string building, use interpolation"], results[:messages]
  end

  def test_for_kernel_format
    #skip
    source = %q{
      class TwoFer
        def self.two_fer(name="you")
          format("One for %s, one for me.", name)
        end
      end
    }
    results = TwoFer::Analyze.(source)
    assert results[:approve]
    assert_equal ["Rather than using the format method, use interpolation"], results[:messages]
  end

  def test_for_string_format
    #skip
    source = %q{
      class TwoFer
        def self.two_fer(name="you")
          "One for %s, one for me." % name
        end
      end
    }
    results = TwoFer::Analyze.(source)
    assert results[:approve]
    assert_equal ["Rather than using string's format/percentage method, use interpolation"], results[:messages]
  end

  def test_conditional_with_nil
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name=nil)
          if name == nil
            "One for you, one for me."
          else
            "One for #{name}, one for me."
          end
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["You could set the default value to 'you' to avoid conditionals"], results[:messages]
  end

  def test_conditional_with_nil_reversed
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name=nil)
          if nil == name
            "One for you, one for me."
          else
            "One for #{name}, one for me."
          end
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["You could set the default value to 'you' to avoid conditionals"], results[:messages]
  end

  def test_conditional_with_string
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name='dog')
          if name == 'dog'
            "One for you, one for me."
          else
            "One for #{name}, one for me."
          end
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert_equal ["You could set the default value to 'you' to avoid conditionals"], results[:messages]
  end

  def test_unknown_solution
    #skip
    source = %q{
      module TwoFer
        def self.two_fer(name=nil)
          I.have.no.idea.what.this.is
        end
      end
    }
    results = TwoFer::Analyze.(source)
    refute results[:approve]
    assert results[:refer_to_mentor]
    assert_equal [], results[:messages]
  end
end

# Explicit return
=begin
class TwoFer
  def self.two_fer(name="you")
    return "One for #{name}, one for me."
  end
end
=end

# Use of premature return
=begin
class TwoFer
  class << self
    def two_fer(name = "")
      return "One for you, one for me." if name.empty?
      "One for #{name}, one for me."
    end
  end
end
=end
