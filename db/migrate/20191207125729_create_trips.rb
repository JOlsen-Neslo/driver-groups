class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.text :location_name, null: false
      t.text :destination_name, null: false
      t.float :distance, null: false
      t.integer :time_slot, null: false
      t.integer :employee_name_id, null: false
      t.float :location_latitude, null: false
      t.float :location_longitude, null: false
      t.st_point :location_long_lat, geographic: true
      t.float :destination_latitude, null: false
      t.float :destination_longitude, null: false
      t.st_point :destination_long_lat, geographic: true
      t.integer :grouped_trip_id
      t.integer :status, null: false, default: 0
      t.float :distance_to_closest_trip

      t.timestamps
    end

    add_index :trips, :location_long_lat, using: :gist
    add_index :trips, :destination_long_lat, using: :gist
  end
end
