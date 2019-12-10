class Trip < ApplicationRecord

  before_save :create_long_lat
  has_one :name

  scope :within_location, -> (longitude, latitude, distance_in_kms = 5) {
    where(%{
     ST_Distance(location_long_lat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_kms])
  }

  scope :within_destination, -> (longitude, latitude, distance_in_kms = 5) {
    where(%{
     ST_Distance(destination_long_lat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_kms])
  }

  enum status: {
      pending: 0,
      scheduled: 1,
      in_progress: 2,
      incomplete: 3,
      complete: 4
  }

  private

  def create_long_lat
    factory = RGeo::Geographic.simple_mercator_factory
    self.location_long_lat = factory.point(self.location_longitude, self.location_latitude)
    self.destination_long_lat = factory.point(self.destination_longitude, self.destination_latitude)
  end

end
