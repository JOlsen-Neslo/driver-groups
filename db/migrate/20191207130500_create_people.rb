class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.date :date_of_birth
      t.integer :user_id

      t.timestamps
    end
  end
end
