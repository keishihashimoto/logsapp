class CreateTroubles < ActiveRecord::Migration[6.0]
  def change
    create_table :troubles do |t|
      t.references :server, null: false, foreign_key: true
      t.datetime :trouble_start, null: false
      t.datetime :trouble_end
      t.integer :checked_count
      t.decimal :trouble_time, precision: 15, scale: 1
      t.timestamps
    end
  end
end
