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
    return true if lines_of_code.nil?
    return false if solution.code.nil?
    solution.code.size <= lines_of_code
  end
end

class GoalResult
  def initialize(goal,board,solution)
    @goal = goal
    @board = board
    @solution = solution
  end
  def lines_of_code_goal_met?
    @goal.lines_of_code_goal_met?(@board,@solution)
  end

  def lines_of_code_goal?
    !@goal.lines_of_code.nil?
  end

  def beacon_goals_met?
    @goal.beacon_goals_met?(@board,@solution)
  end

  def beacon_goals?
    !(@goal.beacons.nil? || @goal.beacons.emtpy?)
  end
  def carl_goal_met?
    @goal.carl_goal_met?(@board,@solution)
  end
end
