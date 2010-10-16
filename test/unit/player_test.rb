require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "solutions relationship works" do
    one = players(:one)
    assert_equal 2,one.solutions.size
    one.solutions.each do |solution|
      assert_equal one,solution.player,"Solution #{solution.id}'s player was #{solution.player} and not #{one}"
    end
    new_player = players(:new_player)
    assert_equal 1,new_player.solutions.size
    advanced_player = players(:advanced_player)
    assert_equal 0,advanced_player.solutions.size
  end
end
