class CreateServers < ActiveRecord::Migration[6.0]
  def change
    create_table :servers do |t|
      t.string :ip_address, null: false
      t.timestamps
    end
  end
end
