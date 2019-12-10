class CreateGroupedTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :grouped_trips do |t|
      t.string :tag, null: false
      t.integer :time_slot

      t.timestamps
    end
  end
end
