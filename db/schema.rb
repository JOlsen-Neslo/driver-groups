# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_07_130500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "grouped_trips", force: :cascade do |t|
    t.string "tag", null: false
    t.integer "time_slot"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "names", force: :cascade do |t|
    t.string "value", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", force: :cascade do |t|
    t.date "date_of_birth"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trips", force: :cascade do |t|
    t.text "location_name", null: false
    t.text "destination_name", null: false
    t.float "distance", null: false
    t.integer "time_slot", null: false
    t.integer "employee_name_id", null: false
    t.float "location_latitude", null: false
    t.float "location_longitude", null: false
    t.geography "location_long_lat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.float "destination_latitude", null: false
    t.float "destination_longitude", null: false
    t.geography "destination_long_lat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.integer "grouped_trip_id"
    t.integer "status", default: 0, null: false
    t.float "distance_to_closest_trip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destination_long_lat"], name: "index_trips_on_destination_long_lat", using: :gist
    t.index ["location_long_lat"], name: "index_trips_on_location_long_lat", using: :gist
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
