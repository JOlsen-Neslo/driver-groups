class GroupedTripsController < ApplicationController
  include SessionsHelper
  skip_before_action :verify_authenticity_token

  before_action :logged_in_user, only: [:show, :create]

  def index
    @slots = [
        ['5PM', 5],
        ['6PM', 6],
        ['7PM', 7],
        ['8PM', 8],
        ['9PM', 9],
        ['10PM', 10],
        ['11PM', 11],
        ['12AM', 12]
    ]
  end

  def create
    time_slot = group_params[:time_slot]

    retrieve_trips(time_slot)
    return redirect_to grouped_trip_path(time_slot) unless @trips.any?

    count = retrieve_count(time_slot)
    pickup_count = map_locations('location')
    count = map_counted_trips pickup_count, 'location', time_slot, count

    retrieve_trips(time_slot)
    return redirect_to grouped_trip_path(time_slot) unless @trips.any?

    destination_count = map_locations('destination')
    count = map_counted_trips destination_count, 'destination', time_slot, count

    retrieve_trips(time_slot)
    return redirect_to grouped_trip_path(time_slot) unless @trips.any?

    map_stragglers @trips, time_slot, count

    redirect_to grouped_trip_path(time_slot)
  end

  def show
    @time_slot = require_id
    @grouped_trips = GroupedTrip.where(time_slot: @time_slot)
    unless @grouped_trips.any?
      flash[:error] = 'Grouped trip cannot be found'
      redirect_to grouped_trips_path
    end

    @grouped_trips
  end

  private

  def map_stragglers(trips, time_slot, count)
    trips.each do |trip|
      create_grouped_trip trip, time_slot, count
      count += 1
    end
  end

  def map_counted_trips(counted_trips, type, time_slot, count)
    clone = counted_trips.clone
    counted_trips.reduce(clone) do |acc, (_name, trips)|
      unless trips.size > 1
        acc = acc.except!(_name)
        next acc
      end

      farthermost_trip = trips.first
      if type == 'location'
        closest_trips = Trip.where(status: 0, time_slot: time_slot, grouped_trip_id: nil)
                            .within_location(farthermost_trip.location_longitude, farthermost_trip.location_latitude)
      else
        closest_trips = Trip.where(status: 0, time_slot: time_slot, grouped_trip_id: nil)
                            .within_destination(farthermost_trip.destination_longitude, farthermost_trip.destination_latitude)
      end

      if closest_trips.empty?
        acc = acc.except!(_name)
        next acc
      end

      acc[_name+count.to_s] = trips if closest_trips.size > 4

      trips_to_map = closest_trips.limit(4)
      create_grouped_trip trips_to_map, time_slot, count
      count += 1

      acc.except!(_name)
    end

    count
  end

  def create_grouped_trip(closest_trips, time_slot, count)
    grouped_trip = GroupedTrip.new
    grouped_trip.tag = count
    grouped_trip.time_slot = time_slot

    grouped_trip.trips << closest_trips
    grouped_trip.save

    update_statuses closest_trips
  end

  def update_statuses(trips)
    if trips.is_a? Trip
      trips.status = 'scheduled'
      trips.save
    else
      trips.each do |trip|
        trip.status = 'scheduled'
        trip.save
      end
    end
  end

  def retrieve_trips(time_slot)
    @trips = Trip.where(status: 0, time_slot: time_slot, grouped_trip_id: nil)
                 .sort_by(&:distance)
                 .reverse
  end

  def retrieve_count(time_slot)
    grouped_trip = GroupedTrip.where(time_slot: time_slot).last
    if grouped_trip.nil?
      count = 0
    else
      count = grouped_trip.tag.to_i + 1
    end

    count
  end

  def map_locations(type)
    locations = {}
    @trips.each do |trip|
      name = trip.send(type + '_name')
      names = locations[name]
      if names.nil?
        names = []
      end

      names.push(trip)
      locations[name] = names
    end

    locations
  end

  def group_params
    params.permit(:time_slot)
  end

  def page_params
    params.permit(:page)
  end

  def require_id
    params.require(:id)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Unauthorized'
      redirect_to login_url
    end
  end
end
