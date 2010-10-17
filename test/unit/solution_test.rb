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

  test "parse code with control structurs" do
    code = [
      'loop front_clear',
        'move',
        'move',
      'end',
      'loop not_front_clear',
      'end',
      'loop front_clear',
        'iterate 3',
          'turnleft',
        'end',
        'move',
      'end',
      'turnleft'
    ]
    one = solutions(:one)
    one.parse_code(code)
    check = one
    2.times do |x|
      assert_equal Loop,check.code[0].class
      assert_equal ['move','move'],check.code[0].code
      assert_equal Loop,check.code[1].class
      assert_equal [],check.code[1].code

      loop_with_nested = check.code[2]
      assert_equal Loop,loop_with_nested.class
      assert_equal 2,loop_with_nested.code.size

      first = loop_with_nested.code[0]
      second = loop_with_nested.code[1]

      assert_equal Iterate,first.class
      assert_equal 3,first.condition
      assert_equal 'turnleft',first.code[0]
      assert_equal 'move',second
      one.save
      check = Solution.find_by_id(one.id)
    end
    puts check.code.to_yaml

  end

  test "level relationship works" do
    one = solutions(:one)
    assert_not_nil one.level
    assert_equal 1,one.level.id

    three = solutions(:three)
    assert_not_nil three.level
    assert_equal 1,three.level.id
  end
end
