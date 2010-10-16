require 'test_helper'

class ExecutorTest < ActiveSupport::TestCase
  test "no code does nothing" do
    board = Board.new
    carl = CarlTheRobot.new
    board.place_carl(0,0)
    board.add_beacon(1,0)
    board.add_beacon(0,1)
    executor = Executor.new(board,carl,[])
    new_board = executor.execute

    assert_equal [0,0],new_board.carl
    assert new_board.beacon?(1,0)
    assert new_board.beacon?(0,1)
  end

  test "successful program" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,1)
    board.add_beacon(1,0)
    board.add_beacon(6,0)
    executor = Executor.new(board,carl,['move','turnleft','move','pickbeacon','turnleft','move','putbeacon'])
    new_board = executor.execute

    assert_equal [7,0],new_board.carl
    assert_equal :south,carl.direction
    assert new_board.beacon?(7,0)
    assert new_board.beacon?(1,0)
    assert !new_board.beacon?(6,0)
  end

  test "pickup when no beacon explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,1)
    board.add_beacon(1,0)
    board.add_beacon(6,0)
    executor = Executor.new(board,carl,['pickbeacon'])
    explosion = assert_raises Explosion do
      new_board = executor.execute
    end
    assert_equal [7,1],explosion.where?
  end

  test "putdown when carl has no beacon explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,1)
    board.add_beacon(1,0)
    board.add_beacon(6,0)
    executor = Executor.new(board,carl,['putbeacon'])
    explosion = assert_raises Explosion do
      new_board = executor.execute
    end
    assert_equal [7,1],explosion.where?
  end

  test "oob explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(0,0)
    executor = Executor.new(board,carl,['move'])
    explosion = assert_raises Explosion do
      new_board = executor.execute
    end
    assert_equal [-1,0],explosion.where?
  end

  test "hitting wall explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(1,1)
    board.map[0][1] = :wall
    executor = Executor.new(board,carl,['move'])
    explosion = assert_raises Explosion do
      new_board = executor.execute
    end
    assert_equal [0,1],explosion.where?
  end
end
