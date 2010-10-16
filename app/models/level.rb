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

class Goal
  # Coordinate of where carl must end up
  attr_accessor :carl
  # Array of coordinates where beacons must be brought
  attr_accessor :beacons
  # Number of lines or less that the solution must be
  attr_accessor :lines_of_code

  # Returns true if this board configuration satisfies the goals
  def achieved?(board)
    false
  end
end
