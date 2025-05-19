require "test_helper"

class LeapTest < Minitest::Test
  def test_date_leap_method_is_disapproved
    source = <<~SOURCE
      class Year
        def self.leap?(year)
          Date.leap?(year)
        end
      end
    SOURCE

    results = Leap::Analyze.(source)
    assert_equal :disapprove, results[:status]
    assert_equal ["ruby.leap.std_lib"], results[:comments]
  end

  def test_date_julian_leap_method_is_disapproved
    source = <<~SOURCE
      class Year
        def self.leap?(year)
          Date.julian_leap?(year)
        end
      end
    SOURCE

    results = Leap::Analyze.(source)
    assert_equal :disapprove, results[:status]
    assert_equal ["ruby.leap.std_lib"], results[:comments]
  end

  def test_date_gregorian_leap_method_is_disapproved
    source = <<~SOURCE
      class Year
        def self.leap?(year)
          Date.gregorian_leap?(year)
        end
      end
    SOURCE

    results = Leap::Analyze.(source)
    assert_equal :disapprove, results[:status]
    assert_equal ["ruby.leap.std_lib"], results[:comments]
  end

  def test_custom_implementation_referred_to_mentor
    source = <<~SOURCE
      class Year
        def self.leap?(year)
          year % 4 == 0
        end
      end
    SOURCE

    results = Leap::Analyze.(source)
    assert_equal :refer_to_mentor, results[:status]
    assert_empty results[:comments]
  end
end
