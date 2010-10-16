require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  test "serialization works" do
    one = solutions(:one)

    code = one.code
    assert_equal 1,code.size
    assert_equal 'turnleft',code[0]

    two = solutions(:two)
    code = two.code
    assert_equal 2,code.size
    assert_equal 'turnleft',code[0]
    assert_equal 'turnleft',code[1]

  end

  test "level relationship works" do
    one = solutions(:one)
    assert_not_nil one.level
    assert_equal 1,one.level.id

    three = solutions(:three)
    assert_not_nil three.level
    assert_equal 2,three.level.id
  end
end
