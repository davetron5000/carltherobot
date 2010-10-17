require 'test_helper'

class LevelsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test "levels requires login" do
    get :index
    assert_response 302
  end

  test "levels requires difficulty" do
    sign_in players(:one)
    get :index
    assert_response :bad_request
  end

  test "get tutorials" do
    sign_in players(:one)
    get :index, :difficulty => 'tutorial'
    assert_response :success
    assert_not_nil assigns(:levels)
    assert_equal 4,assigns(:levels).size
    assert_equal 1,assigns(:levels)[0].ordinal
    assert_equal 2,assigns(:levels)[1].ordinal
  end

  test "get easy" do
    sign_in players(:one)
    get :index, :difficulty => 'easy'
    assert_response :success
    assert_not_nil assigns(:levels)
    assert_equal 1,assigns(:levels).size
  end
  test "get hard" do
    sign_in players(:one)
    get :index, :difficulty => 'hard'
    assert_response :success
    assert_not_nil assigns(:levels)
    assert_equal 3,assigns(:levels).size
    assert_equal 1,assigns(:levels)[0].ordinal
    assert_equal 2,assigns(:levels)[1].ordinal
    assert_equal 3,assigns(:levels)[2].ordinal
  end
end
