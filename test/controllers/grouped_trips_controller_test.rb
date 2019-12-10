require 'test_helper'

class GroupedTripsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grouped_trips_index_url
    assert_response :success
  end

end
