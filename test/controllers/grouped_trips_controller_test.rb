require 'test_helper'

class GroupedTripsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jordan)
    @grouped_trip = grouped_trips(:one)
  end

  test "#index should return time slots" do
    get grouped_trips_path
    assert_response :success
    assert_equal [
                     ['5PM', 5],
                     ['6PM', 6],
                     ['7PM', 7],
                     ['8PM', 8],
                     ['9PM', 9],
                     ['10PM', 10],
                     ['11PM', 11],
                     ['12AM', 12]
                 ], assigns(:slots)
  end

  test "#show should redirect to login if not logged in" do
    get grouped_trip_path @grouped_trip
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test "#show should NOT redirect to login if logged in" do
    log_in_as @user
    get grouped_trip_path({id: 13})
    assert_response :success
    assert flash.empty?
    assert assigns(:grouped_trips).any?
  end

  test "#show should redirect to #index if grouped_trips cannot be found" do
    log_in_as @user
    get grouped_trip_path({id: 212})
    assert_redirected_to grouped_trips_path
  end

  test "#create should redirect to login if not logged in" do
    post grouped_trips_path {}
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test "#create should redirect to grouped_trip allocations for supplied time slot" do
    log_in_as @user
    post grouped_trips_path, params: {time_slot: 12}
    assert_redirected_to grouped_trip_path({id: 12})
  end

  test "#create should group 12 identical ending locations into 3 tags" do
    log_in_as @user
    post grouped_trips_path, params: {time_slot: 5}
    assert_redirected_to grouped_trip_path({id: 5})

    scheduled = GroupedTrip.where(time_slot: 5)
    assert_equal 15, scheduled.size

    grouped_trips = {}
    scheduled.each do |grouped_trip|
      trips = Trip.where(grouped_trip_id: grouped_trip.id)
      if grouped_trips[grouped_trip.tag].nil?
        grouped_trips[grouped_trip.tag] = []
      end

      grouped_trips[grouped_trip.tag] = grouped_trips[grouped_trip.tag] + trips
    end

    puts grouped_trips
    grouped_trips.each do |trip|
      # assert_equal 5, grouped_trips[trip].size
    end
  end

  test "#create should group 4 identical starting locations into 1 tag" do
    log_in_as @user
    post grouped_trips_path, params: {time_slot: 7}
    assert_redirected_to grouped_trip_path({id: 7})

    scheduled = GroupedTrip.where(
        time_slot: 7
    )

    assert_equal 1, scheduled.size

    # TODO: fix up like previous logic
    assert_difference scheduled.tag do
      assert_equal 6, scheduled.time_slot
    end
  end

# TODO: add tests for stragglers and a mix between locations
end