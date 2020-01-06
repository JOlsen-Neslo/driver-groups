require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jordan)
  end

  test "#new should return success" do
    get login_path
    assert_response :success
  end

  test "#create should render #new if not authenticated" do
    post login_path, params: {
        session: {
            username: 'jolsen',
            password: 'tests'
        }
    }
    assert_template 'sessions/new'
    assert_not flash.empty?
  end

  test "#create should redirect to root path when authenticated" do
    post login_path, params: {
        session: {
            username: 'jolsen',
            password: 'test'
        }
    }
    assert_redirected_to user_path(@user)
    assert flash.empty?
    assert session[:user_id].present?
  end

  test "#destroy redirect to root following log out" do
    log_in_as @user
    assert session[:user_id].present?
    delete logout_path(@user)
    assert_redirected_to root_path
    assert session[:user_id].nil?
  end

end
