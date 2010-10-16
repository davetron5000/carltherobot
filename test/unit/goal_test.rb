require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  test "basic goal satisfaction for carl" do
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [0,0]
    assert_empty g.check_goals(b)
  end

  test "basic goal NON-satisfaction for carl" do
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [1,0]
    assert g.check_goals(b).include? :carl
  end

  test "goal satisfaction for beacons" do 
    b = Board.new
    b.place_carl(0,0)
    b.add_beacon(1,0)
    b.add_beacon(0,1)
    g = Goal.new
    g.carl = [0,0]
    g.beacons = [ [1,0], [0,1] ]
    assert_empty g.check_goals(b)
  end

  test "goal NON-satisfaction for beacons" do 
    b = Board.new
    b.place_carl(0,0)
    g = Goal.new
    g.carl = [0,0]
    g.beacons = [ [1,0], [0,1] ]
    assert g.check_goals(b).include?([:beacon,[0,1]]),g.check_goals(b).inspect
    assert g.check_goals(b).include?([:beacon,[1,0]]),g.check_goals(b).inspect
    b.add_beacon(1,0)
    assert g.check_goals(b).include?([:beacon,[0,1]])
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
    assert g.check_goals(b,s).include?(:code_size),g.check_goals(b,s).inspect
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
    assert_empty g.check_goals(b,s)
  end

  private

  def assert_empty(array)
    assert array.empty?
  end
end
