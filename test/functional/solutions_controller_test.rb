require 'test_helper'

class SolutionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "solutions requires login" do
    get :index
    assert_response 302
  end

  test "can see my solutions" do
    sign_in players(:one)
    get :index
    assert_response :success
    assert_not_nil assigns(:solutions)
    assert_equal 2,assigns(:solutions).size
  end

  test "can see one solution" do
    sign_in players(:new_player)
    get :show, :id => 3
    assert_response :success
    assert_not_nil assigns(:solution)
    assert_not_nil assigns(:level)
    assert_not_nil assigns(:board0)
    assert_not_nil assigns(:execution_result0)
    assert !assigns(:execution_result0).carl_goal_met?
    assert !assigns(:execution_result0).beacon_goals_met?
    assert assigns(:execution_result0).lines_of_code_goal_met?
    assert_equal [5,0],assigns(:board0).carl
  end

  test "can get the new form for a new solution" do
    sign_in players(:one)
    get :new
    assert_response :success
    assert_not_nil assigns(:solution)
    assert_not_nil assigns(:level)
    assert_not_nil assigns(:board0)
    assert_not_nil assigns(:execution_result0)
    assert !assigns(:execution_result0).carl_goal_met?
    assert !assigns(:execution_result0).beacon_goals?
    assert !assigns(:execution_result0).lines_of_code_goal_met?
    assert_equal assigns(:solution).player_id,players(:one).id
  end

  test "can create a new solution" do
    player = players(:advanced_player)
    sign_in player
    post :create, :code => "move\nturnleft"
    solutions = player.solutions
    assert_equal 1,solutions.size
    assert_equal ['move','turnleft'],solutions[0].code
    assert_redirected_to :action => :edit, :id => solutions[0].id
  end

  test "can get the edit form" do
    sign_in players(:one)
    get :edit, :id => 1
    assert_response :success
    assert_not_nil assigns(:solution)
  end

  test "can edit an existing solution" do
    player = players(:new_player)
    sign_in player
    put :update, :id => 3, :code => [
      'move',
      'move',
      'move',
      'move',
      'move',
      'move',
      'turnleft',
      'turnleft',
      'turnleft',
      'move'
    ].join("\n")

    solutions = player.solutions
    assert_equal 1,solutions.size
    assert_redirected_to :action => :edit, :id => solutions[0].id

    get :show, :id => 3
    assert_response :success
    assert_not_nil assigns(:solution)
    assert_not_nil assigns(:level)
    assert_not_nil assigns(:board0)
    assert_not_nil assigns(:execution_result0)
    assert assigns(:execution_result0).carl_goal_met?
    assert !assigns(:execution_result0).beacon_goals_met?
    assert assigns(:execution_result0).lines_of_code_goal_met?
  end

  test "cannot see someone else's solution" do
    sign_in players(:one)
    get :show, :id => 3
    assert_response :forbidden
  end

  test "cannot edit someone else's solution" do
    sign_in players(:one)
    get :edit, :id => 3
    assert_response :forbidden
  end

  test "cannot update someone else's solution" do
    sign_in players(:one)
    put :update, :id => 3, :code => 'move'
    assert_response :forbidden
  end
end
