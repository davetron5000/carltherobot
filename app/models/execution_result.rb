class ExecutionResult
  attr_reader :carl
  attr_reader :last_line
  def initialize(goal,board,solution,exploded,carl,last_line)
    @goal = goal
    @board = board
    @solution = solution
    @exploded = exploded
    @carl = carl
    @last_line = last_line
  end

  def exploded?; @exploded; end

  def success?
    return false if exploded?
    lines_of_code_goal_met? && carl_goal_met? && beacon_goals_met?
  end

  def lines_of_code_goal_met?
    return false if exploded?
    @goal.lines_of_code_goal_met?(@board,@solution)
  end

  def lines_of_code_goal?
    !@goal.lines_of_code.nil?
  end

  def beacon_goals_met?
    @goal.beacon_goals_met?(@board,@solution)
  end

  def beacon_goals?
    !(@goal.beacons.nil? || @goal.beacons.empty?)
  end
  def carl_goal_met?
    return false if exploded?
    @goal.carl_goal_met?(@board,@solution)
  end
end
