class ExecutionResult
  def initialize(goal,board,solution,exploded)
    @goal = goal
    @board = board
    @solution = solution
    @exploded = exploded
  end

  def exploded?; @exploded; end

  def success?
    lines_of_code_goal_met? && carl_goal_met? && beacon_goals_met?
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
    !(@goal.beacons.nil? || @goal.beacons.empty?)
  end
  def carl_goal_met?
    @goal.carl_goal_met?(@board,@solution)
  end
end
