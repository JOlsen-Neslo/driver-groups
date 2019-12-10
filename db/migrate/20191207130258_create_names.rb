class CreateNames < ActiveRecord::Migration[6.0]
  def change
    create_table :names do |t|
      t.string :value, null: false
      t.integer :person_id, null: false

      t.timestamps
    end
  end
end
