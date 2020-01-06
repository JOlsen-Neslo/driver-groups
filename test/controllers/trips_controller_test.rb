require 'test_helper'

class TripsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jordan)
  end

  test "#index should redirect to login if not logged in" do
    get trips_path
    assert_redirected_to login_path
  end

  test "#index should return success if logged in" do
    log_in_as @user
    get trips_path
    assert_response :success
    assert_not assigns(:trips).nil?
    assert_equal 10, assigns(:trips).size
  end

  test "#show should redirect to login if not logged in" do
    get trip_path({ id: 1 })
    assert_redirected_to login_path
  end

  test "#show should NOT redirect to login if logged in" do
    log_in_as @user
    get trip_path(Trip.first)
    assert_response :success
    assert_not assigns(:trip).nil?
  end

  test "#show should redirect to #index if trip cannot be found" do
    log_in_as @user
    get trip_path({ id: 300 })
    assert_redirected_to trips_path
    assert_not flash.empty?
  end

end
