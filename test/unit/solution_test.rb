require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "serialization works" do
    one = solutions(:one)

    code = one.code
    assert_equal 1,code.size
    assert_equal 'move',code[0]

    two = solutions(:two)
    code = two.code
    assert_equal 2,code.size
    assert_equal 'move',code[0]
    assert_equal 'foobar',code[1]

  end
end
