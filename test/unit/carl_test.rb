require 'test_helper'

class CarlTest < ActiveSupport::TestCase
  test "turnleft" do
    c = CarlTheRobot.new
    assert_equal :north,c.direction
    c.turnleft
    assert_equal :west,c.direction
    c.turnleft
    assert_equal :south,c.direction
    c.turnleft
    assert_equal :east,c.direction
    c.turnleft
    assert_equal :north,c.direction
  end

  test "barfs" do
    c = CarlTheRobot.new
    c.pickup_beacon
    c.putdown_beacon
    assert_raises Explosion do
      c.putdown_beacon
    end
  end
end
