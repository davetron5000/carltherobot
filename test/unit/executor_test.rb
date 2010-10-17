require 'test_helper'

class ExecutorTest < ActiveSupport::TestCase
  test "no code does nothing" do
    board = Board.new
    carl = CarlTheRobot.new
    board.place_carl(0,0)
    board.add_beacon(1,0)
    board.add_beacon(0,1)
    executor = Executor.new(board,carl,[])
    new_board = executor.execute!

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
    new_board = executor.execute!

    assert_equal [7,0],new_board.carl
    assert_equal :south,carl.direction
    assert new_board.beacon?(7,0)
    assert new_board.beacon?(1,0)
    assert !new_board.beacon?(6,0)
  end

  test "last line count works for branch" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,0)
    board.add_beacon(7,1)
    board.map[6][0] = :wall
    board.map[7][1] = :wall
    executor = Executor.new(board,
                            carl,
                            [
                              Branch.new('front_clear',['move']),
                              Branch.new('not_front_clear',
                                         [
                                           'turnleft',
                                           'turnleft',
                                           'turnleft',]
                                        ),
                              'move',

    ])
    assert_raises Explosion do 
      new_board = executor.execute!
    end
    assert_equal 7,executor.last_index
  end

  test "last line count works for iterate" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(5,5)
    board.map[5][6] = :wall
    executor = Executor.new(board,
                            carl,
                            [
                              Iterate.new(1,['move']),
                              Iterate.new(3,['turnleft','move']),
                              'move',
    ])
    assert_raises Explosion do 
      new_board = executor.execute!
    end
    assert_equal 6,executor.last_index
  end

  test "last line count works for while" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(5,5)
    board.map[5][6] = :wall
    board.map[5][5] = :beacon
    executor = Executor.new(board,
                            carl,
                            [
                              Loop.new('front_clear',['move']),
                              Loop.new('not_front_clear',['turnleft','turnleft']),
                              'turnleft',
                              'turnleft',
                              'move'
    ])
    ex = assert_raises Explosion do 
      new_board = executor.execute!
    end
    assert_equal 8,executor.last_index
  end

  test "last line count works for while 3" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(5,5)
    board.map[5][4] = :wall
    executor = Executor.new(board,
                            carl,
                            [
                              Loop.new('front_clear',['move']),
                              'move'
    ])
    ex = assert_raises Explosion do 
      new_board = executor.execute!
    end
    assert_equal 2,executor.last_index
  end

  test "last line count works for while 2" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(5,5)
    board.map[5][6] = :wall
    executor = Executor.new(board,
                            carl,
                            [
                              Loop.new('front_clear',['move']),
                              'move'
    ])
    ex = assert_raises Explosion do 
      new_board = executor.execute!
    end
    assert_equal 2,executor.last_index
  end

  test "branch works" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,0)
    board.add_beacon(7,1)
    board.map[6][0] = :wall
    executor = Executor.new(board,
                            carl,
                            [
                              Branch.new('front_clear',['move']),
                              Branch.new('not_front_clear',
                                         [
                                           'turnleft',
                                           'turnleft',
                                           'turnleft',
                                           Branch.new('not_front_clear',['move'])]
                                        ),
                              'move',
                              'turnleft','turnleft','turnleft',
                              Branch.new('front_clear',['move']),
                              Branch.new('not_front_clear',['turnleft','move']),
    ])
    new_board = executor.execute!
    assert new_board.carl?(7,2)
  end

  test "loop works" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,0)
    board.add_beacon(7,1)
    board.map[4][0] = :wall
    executor = Executor.new(board,
                            carl,
                            [ Loop.new('front_clear',['move']),
    ])
    new_board = executor.execute!
    assert new_board.carl?(5,0)
  end

  test "iterate works" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,0)
    board.add_beacon(7,1)
    board.map[4][0] = :wall
    executor = Executor.new(board,
                            carl,
                            [ Iterate.new(2,['move']),
                            Iterate.new(3,['turnleft']),
                            'move',
    ])
    new_board = executor.execute!
    assert new_board.carl?(5,1)
    assert_equal :east,carl.direction
  end

  test "infinite loop barfs" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,0)
    board.add_beacon(7,1)
    board.map[4][0] = :wall
    executor = Executor.new(board,
                            carl,
                            [ Loop.new('front_clear',['turnleft','turnleft','turnleft','turnleft']),
    ])
    explosion = assert_raises Explosion do 
      new_board = executor.execute!
    end
    assert_equal "Possible Infinite Loop",explosion.message
  end

  test "pickup when no beacon explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(7,1)
    board.add_beacon(1,0)
    board.add_beacon(6,0)
    executor = Executor.new(board,carl,['pickbeacon'])
    explosion = assert_raises Explosion do
      new_board = executor.execute!
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
      new_board = executor.execute!
    end
    assert_equal [7,1],explosion.where?
  end

  test "oob explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(0,0)
    executor = Executor.new(board,carl,['move'])
    explosion = assert_raises Explosion do
      new_board = executor.execute!
    end
    assert_equal [0,0],explosion.where?
  end

  test "hitting wall explodes" do
    carl = CarlTheRobot.new
    board = Board.new
    board.place_carl(1,1)
    board.map[0][1] = :wall
    executor = Executor.new(board,carl,['move'])
    explosion = assert_raises Explosion do
      new_board = executor.execute!
    end
    assert_equal [0,1],explosion.where?
  end
end
