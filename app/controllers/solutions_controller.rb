require 'carl.rb'

class SolutionsController < ApplicationController
  before_filter :authenticate_player!
  before_filter :check_access, :except => [:new,:create,:index]

  def index
    @solutions = Solution.find_all_by_player_id(current_player.id)
  end

  def create
    code = params[:code].split(/\n/).map(&:strip).select{ |x| x.size > 0 }
    solution = Solution.new(:player_id => current_player.id, :level_id => params[:level_id])
    solution.parse_code(code)
    solution.save
    redirect_to edit_solution_url(solution)
  end

  def new
    @solution = Solution.new(:player_id => current_player.id, :level => Level.find_by_id(params[:level_id]))
    set_assigns(@solution)
  end

  def edit
  end

  def show
  end

  def update
    code = params[:code].split(/\n/).map(&:strip)
    @solution.parse_code(code)
    @solution.save
    redirect_to edit_solution_url(@solution)
  end

  private
  def check_access
    solution = Solution.find_by_id(params[:id])
    if solution.nil?
      head :not_found
    else
      if solution.player_id != current_player.id
        head :forbidden
      else
        @solution = solution
        set_assigns(@solution)
      end
    end
  end

  def set_assigns(solution)
    @level = solution.level
    @execution_result0,@board0 = execute_solution(@level.goal,@level.board0,solution)
    @execution_result1,@board1 = execute_solution(@level.goal,@level.board1,solution)
    if @execution_result0.success?
      @solution.beat = true
      @solution.save
    end
  end

  def execute_solution(goal,board,solution)
    executor = Executor.new(board,CarlTheRobot.new,solution.code)
    exploded = false
    new_board = nil
    begin
      executor.execute!
      new_board = executor.board
    rescue Explosion => explosion
      exploded = true
      new_board = executor.board
      carl = new_board.carl
      new_board.map[carl[0]][carl[1]] = :explosion
    end
    carl = executor.carl
    last_line = executor.last_index
    execution_result = ExecutionResult.new(goal,new_board,solution,exploded,carl,last_line)
    [execution_result,new_board]
  end
end
