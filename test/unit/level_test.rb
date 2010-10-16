require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "ordering" do
    levels = Level.by_difficulty
    assert_equal 3,levels.size
    assert_equal 2,levels[:tutorial].size
    assert_equal 1,levels[:easy].size
    assert_equal 3,levels[:hard].size
    assert_equal 1,levels[:tutorial][0].ordinal
    assert_equal 2,levels[:tutorial][1].ordinal
    assert_equal 1,levels[:easy][0].ordinal
    assert_equal 1,levels[:hard][0].ordinal
    assert_equal 2,levels[:hard][1].ordinal
    assert_equal 3,levels[:hard][2].ordinal
  end
end
