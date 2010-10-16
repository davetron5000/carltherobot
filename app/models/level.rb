class Level < ActiveRecord::Base
  # Returns all levels organized by difficult, in ordinal order
  def self.by_difficulty
    result = { :tutorial => [], :easy => [], :hard => [] }
    Level.order('ordinal asc').each do |level|
      result[level.difficulty.to_sym] << level
    end
    result
  end

  def boards
    [Board.fake_board]
  end
end

class Board
  attr_accessor :rows
  attr_accessor :columns
  # Goal for this board
  attr_accessor :goal
  # 2x2 array of where the walls are
  attr_accessor :map
  # array of coordinates where beacons are
  attr_accessor :beacons
  # coordinate of where carl is
  attr_accessor :carl

  def self.fake_board
    b = Board.new
    b.rows = 3
    b.columns = 3
    b.goal = Goal.new
    b.goal.carl = [0,2]
    b.beacons = []
    b.carl = [2,0]
    b.map = [ 
      [nil,nil,nil],
      [nil,nil,nil],
      [nil,nil,nil],
    ]
    b
  end
end

class Goal
  # Coordinate of where carl must end up
  attr_accessor :carl
  # Array of coordinates where beacons must be brought
  attr_accessor :beepers
  # Number of lines or less that the solution must be
  attr_accessor :lines_of_code
end
