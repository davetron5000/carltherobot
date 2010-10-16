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

  test "board_serialization" do
    level = Level.find_by_id(1)
    assert_not_nil level.board1
    assert_nil level.board2
    assert level.board1.kind_of? Board

    level = Level.find_by_id(4)
    assert_not_nil level.board1
    assert_not_nil level.board2
  end

  test "empty board behaves" do
    b = Board.new
    8.times do |row|
      8.times do |col|
        assert !b.carl?(row,col),"Didn't expect carl at #{row},#{col}"
        assert !b.wall?(row,col),"Didn't expect wall at #{row},#{col}"
        assert !b.beacon?(row,col),"Didn't expect beacon at #{row},#{col}"
      end
    end
  end

  test "board bounds behave" do
    b = Board.new
    [-1,8].each do |row|
      [-1,8].each do |col|
        assert !b.carl?(row,col),"Didn't expect carl at #{row},#{col}"
        assert b.wall?(row,col),"Expected a wall at #{row},#{col}"
        assert !b.beacon?(row,col),"Didn't expect beacon at #{row},#{col}"
        assert !b.place_carl(row,col),"Didn't expect to be able to place carl at #{row},#{col}"
        assert !b.add_beacon(row,col),"Didn't expect to be able to add a beacon at #{row},#{col}"
        assert !b.remove_beacon(row,col),"Didn't expect to be able to remoe a beacon at #{row},#{col}"
      end
    end
  end

  test "walls behave wrt to placementr" do
    b = Board.new
    b.map[3][2] = :wall
    b.map[3][3] = :wall
    b.map[3][4] = :wall
    assert b.wall?(3,2)
    assert b.wall?(3,3)
    assert b.wall?(3,4)
    assert !b.add_beacon(3,2)
    assert !b.add_beacon(3,3)
    assert !b.add_beacon(3,4)
    assert b.add_beacon(3,5)
    assert !b.place_carl(3,2)
    assert !b.place_carl(3,3)
    assert !b.place_carl(3,4)
    assert b.place_carl(3,5)
    assert b.carl?(3,5)
    assert_equal [3,5],b.carl
  end

  test "copy board" do
    b = Board.new
    b.map[2][3] = :wall
    b.map[3][3] = :wall
    b.map[4][3] = :wall
    b.place_carl(0,0)
    b.add_beacon(7,7)
    b2 = Board.from_board(b)
    assert b2.wall?(2,3)
    assert b2.wall?(3,3)
    assert b2.wall?(4,3)
    assert b2.carl?(0,0)
    assert b2.beacon?(7,7)

    b.map[5][5] = :wall
    assert !b2.wall?(5,5)

    b2.map[1][1] = :wall
    assert !b.wall?(1,1)


  end
end
