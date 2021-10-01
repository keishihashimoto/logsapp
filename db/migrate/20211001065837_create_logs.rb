class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.references :server, null: false, foreign_key: true
      t.datetime :checked_at, null: false
      t.string :interval, null: false
      t.timestamps
    end
  end
end
