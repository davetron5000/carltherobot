# A board is an 8x8 grid
class Board

  # Copies a board
  def self.from_board(board)
    b = Board.new
    b.map  = []
    board.map.each do |x|
      row = []
      x.each { |y| row << y }
      b.map << row
    end
    b.place_carl(*board.carl)
    b
  end

  attr_accessor :map

  # Create an empty board
  def initialize
    @map = []
    8.times do |x|
      row = []
      8.times { |y| row << nil }
      @map << row
    end
  end

  def beacon?(row,col)
    return false if oob?(row,col)
    @map[row][col] == :beacon
  end

  def wall?(row,col)
    return true if oob?(row,col)
    @map[row][col] == :wall
  end

  # Return carl's coordinates as [row,col]
  def carl
    @carl
  end

  def carl?(row,col)
    return false if oob?(row,col)
    @carl == [row,col]
  end

  def place_carl(row,col)
    return false if oob?(row,col)
    return false if wall?(row,col)
    @carl = [row,col];
    true
  end

  def remove_beacon(row,col)
    return false if oob?(row,col)
  end

  def add_beacon(row,col)
    return false if oob?(row,col)
    return false if wall?(row,col)
    @map[row][col] = :beacon
    true
  end

  private 

  def oob?(row,col)
    row < 0 || row > 7 || col < 0 || col > 7
  end
end

