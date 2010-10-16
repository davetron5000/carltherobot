require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  test "basic goal satisfaction for carl" do
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [0,0]
    assert g.carl_goal_met?(b,nil)
  end

  test "basic goal NON-satisfaction for carl" do
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [1,0]
    assert !g.carl_goal_met?(b,nil)
  end

  test "goal satisfaction for beacons" do 
    b = Board.new
    b.place_carl(0,0)
    b.add_beacon(1,0)
    b.add_beacon(0,1)
    g = Goal.new
    g.carl = [0,0]
    g.beacons = [ [1,0], [0,1] ]
    assert g.beacon_goals_met?(b,nil)
  end

  test "goal NON-satisfaction for beacons" do 
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [0,0]
    g.beacons = [ [1,0], [0,1] ]
    assert !g.beacon_goals_met?(b,nil)
    b.add_beacon(1,0)
    assert !g.beacon_goals_met?(b,nil)
  end

  test "goal NON-satisfaction for lines_of_code" do
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [0,0]
    g.lines_of_code = 4
    s = Solution.new
    s.code = ['move']
    s.code << 'turnleft'
    s.code << 'turnleft'
    s.code << 'turnleft'
    s.code << 'turnleft'
    assert !g.lines_of_code_goal_met?(b,s)
  end

  test "goal satisfaction for lines_of_code" do
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [0,0]
    g.lines_of_code = 5
    s = Solution.new
    s.code = ['move']
    s.code << 'turnleft'
    s.code << 'turnleft'
    s.code << 'turnleft'
    s.code << 'turnleft'
    assert g.lines_of_code_goal_met?(b,s)
  end
end
