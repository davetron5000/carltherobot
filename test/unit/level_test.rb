require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "ordering" do
    levels = Level.by_difficulty
    assert_equal 3,levels.size
    assert_equal 4,levels[:tutorial].size
    assert_equal 1,levels[:easy].size
    assert_equal 3,levels[:hard].size
    assert_equal 1,levels[:tutorial][0].ordinal
    assert_equal 2,levels[:tutorial][1].ordinal
    assert_equal 1,levels[:easy][0].ordinal
    assert_equal 1,levels[:hard][0].ordinal
    assert_equal 2,levels[:hard][1].ordinal
    assert_equal 3,levels[:hard][2].ordinal
  end

  test "next" do
    level = Level.find_by_id(2)
    assert_equal 3,level.next.id
    assert_equal 4,level.next.next.id
    assert_equal 'easy',level.next.next.next.difficulty
  end

  test "board_and_goal_serialization" do
    level = Level.find_by_id(1)
    assert_not_nil level.board0
    assert_nil level.board1
    assert level.board0.kind_of? Board

    assert level.goal.kind_of? Goal
    assert_equal [5,0],level.goal.carl
    assert_nil level.goal.beacons
    assert_equal 3,level.goal.lines_of_code

    level = Level.find_by_id(44)
    assert_not_nil level.board0
    assert_not_nil level.board1
  end
end
