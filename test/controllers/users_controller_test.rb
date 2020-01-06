require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jordan)
  end

  test "#new should return success regardless of login" do
    get new_user_path
    assert_response :success
    assert assigns(:user).present?

    log_in_as @user
    get new_user_path
    assert_response :success
    assert assigns(:user).present?
  end

  test "#show should redirect to login if not logged in" do
    get user_path @user
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test "#show should NOT redirect to login if logged in" do
    log_in_as @user
    get user_path @user
    assert_response :success
    assert flash.empty?
    assert assigns(:user).present?
  end

  test "#edit should redirect to login if not logged in" do
    get user_path @user
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test "#edit should NOT redirect to login if logged in" do
    log_in_as @user
    get user_path @user
    assert_response :success
    assert flash.empty?
    assert assigns(:user).present?
  end

  test "#create should display error and redirect to #new if required
              params are missing" do
    users = User.all
    assert_equal 1, users.size
    post users_path, params: {
        user: {
            password: 'test',
            password_confirmation: 'test'
        }
    }
    assert_template 'users/new'
    assert_not flash.empty?
    assert assigns(:user).present?
    users = User.all
    assert_equal 1, users.size
  end

  test "#create should create user if all required params are supplied" do
    users = User.all
    assert_equal 1, users.size
    post users_path, params: {
        user: {
            username: 'test',
            password: 'test',
            password_confirmation: 'test',
            person_attributes: {
                name_attributes: {
                    value: 'Test'
                }
            }
        }
    }
    assert_redirected_to root_path
    assert_not flash.empty?
    assert assigns(:user).present?
    users = User.all
    assert_equal 2, users.size
  end

  test "#update should redirect to login if not logged in" do
    patch user_path @user
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test "#update should display error and redirect to #edit if required
              params are missing" do
    log_in_as @user

    users = User.all
    assert_equal 1, users.size
    user = users.first

    patch user_path(user), params: {
        user: {
            username: nil
        }
    }

    assert_template 'users/edit'
    assert_not flash.empty?
    assert assigns(:user).present?

    user.reload
    assert user.username.present?
  end

  test "#update should update user if all required params are supplied" do
    log_in_as @user

    users = User.all
    assert_equal 1, users.size
    user = users.first

    patch user_path(user), params: {
        user: {
            username: 'Next'
        }
    }

    assert_redirected_to user_path
    assert_not flash.empty?
    assert assigns(:user).present?

    user.reload
    assert_equal 'Next', user.username
  end

end
