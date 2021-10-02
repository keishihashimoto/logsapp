class CreateServers < ActiveRecord::Migration[6.0]
  def change
    create_table :servers do |t|
      t.string :ip_address
      t.integer :main_1, null: false
      t.integer :main_2, null: false
      t.integer :main_3, null: false
      t.integer :main_4, null: false
      t.integer :sub, null: false
      t.timestamps
    end
  end
end
