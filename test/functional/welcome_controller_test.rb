require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should not get secret without login" do
    get :secret
    assert_response 302
  end

  test "should get secret with login" do
    sign_in players(:one)
    get :secret
    assert_response :success
  end

end
