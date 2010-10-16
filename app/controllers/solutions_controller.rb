class SolutionsController < ApplicationController
  before_filter :authenticate_player!
  before_filter :check_access, :except => [:new,:create,:index]

  def index
    @solutions = Solution.find_all_by_player_id(current_player.id)
  end

  def create
    code = params[:code].split(/\n/).map(&:strip)
    solution = Solution.new(:player_id => current_player.id, :code => code, :level_id => params[:level_id])
    solution.save
    redirect_to edit_solution_url(solution)
  end

  def new
    @solution = Solution.new(:player_id => current_player.id, :level => Level.find_by_difficulty_and_ordinal('tutorial',1))
    set_assigns(@solution)
  end

  def edit
  end

  def show
  end

  def update
    code = params[:code].split(/\n/).map(&:strip)
    @solution.code = code
    @solution.save
    redirect_to edit_solution_url(@solution)
  end

  private
  def check_access
    solution = Solution.find_by_id(params[:id])
    if solution.player_id != current_player.id
      head :forbidden
    else
      @solution = solution
      set_assigns(@solution)
    end
  end

  def set_assigns(solution)
    @level = solution.level
    @board0 = @level.board0
    @board1 = @level.board1
    @execution_result0 = ExecutionResult.new(@level.goal,@board0,solution,false)
    @execution_result1 = ExecutionResult.new(@level.goal,@board1,solution,false) unless @board1.nil?
  end
end
