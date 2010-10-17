require 'test_helper'

class ConditionsTest < ActiveSupport::TestCase
  test "front_clear" do
    b = Board.new
    b.map[0][0] = :wall
    assert Conditions.front_clear([1,0],:south,b)
    assert !Conditions.front_clear([1,0],:north,b)
    assert !Conditions.not_front_clear([1,0],:south,b)
    assert Conditions.not_front_clear([1,0],:north,b)
  end

  test "on_beacon" do
    b = Board.new
    b.map[0][0] = :wall
    b.map[0][1] = :beacon
    assert Conditions.on_beacon([0,1],:south,b)
    assert !Conditions.on_beacon([1,0],:north,b)
    assert !Conditions.not_on_beacon([0,1],:south,b)
    assert Conditions.not_on_beacon([1,0],:north,b)
  end
end
