class Goal
  # Coordinate of where carl must end up
  attr_accessor :carl
  # Array of coordinates where beacons must be brought
  attr_accessor :beacons
  # Number of lines or less that the solution must be
  attr_accessor :lines_of_code

  def carl_goal_met?(board,solution)
    carl == board.carl
  end

  def beacon_goals_met?(board,solution)
    unless beacons.nil?
      return false unless beacons.select { |beacon| board.beacon? *beacon }.size == beacons.size
    end
    true
  end

  def lines_of_code_goal_met?(board,solution)
    solution.code.size <= lines_of_code
  end
end

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

class Level < ActiveRecord::Base
  serialize :board0, Board
  serialize :board1, Board
  serialize :goal, Goal

  # Returns all levels organized by difficult, in ordinal order
  def self.by_difficulty
    result = { :tutorial => [], :easy => [], :hard => [] }
    Level.order('ordinal asc').each do |level|
      result[level.difficulty.to_sym] << level
    end
    result
  end
end
# class Doit
#   carl.board = board.copy
#   solution.code.each { |command| self.execute(command) }
#   begin
#   if level.goal.satisfies?(board)
#     win!
#   else
#     fail!
#   end
#   rescue "explosion"
#     carls -= 1
#   end
# end
# 
# 
# class Carl
#   attr_accessor :board
# 
#   def execute(command)
#     if command == :move
#       if board.clear?(board.carl + self.direction)
#         move
#       else
#         explode
#       end
#     elsif command == :turnleft
#       rotate
#     elsif command == :pickbeacon
#       explode unless board.beacon_at?(board.carl)
#       board.remove_beacon_at(board.carl)
#       @beacons += 1
#     elsif command == :putbeacon
#       explode unless has_beacons?
#       explode if board.beacon_at?(board.carl)
#       board.add_beacon(board.carl)
#       @beacons -= 1
#     elsif command.kind_of? Loop
#       count = 0
#       while command.true?(board,self)
#         command.each do |cmd|
#           self.execute(cmd)
#         end
#         count += 1
#         explode if count > 20
#       end
#     elsif command.kind_of? Branch
#       if command.true?(board,self)
#         command.each { |cmd| self.execute(cmd) }
#       end
#     elsif command.kind_of? Iterate
#       command.times { command.each { |cmd| self.execute(cmd) } }
#     elsif command.kind_of? Subroutine
#       command.each { |cmd| self.execute(cmd) }
#     else
#       explode
#     end
# 
#   end
# 
#   def explode
#     raise "Explode!"
#   end
# end
