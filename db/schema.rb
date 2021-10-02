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

ActiveRecord::Schema.define(version: 2021_10_01_065916) do

  create_table "logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "server_id", null: false
    t.datetime "checked_at", null: false
    t.string "interval", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["server_id"], name: "index_logs_on_server_id"
  end

  create_table "servers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ip_address"
    t.integer "main_1", null: false
    t.integer "main_2", null: false
    t.integer "main_3", null: false
    t.integer "main_4", null: false
    t.integer "sub", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "troubles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "server_id", null: false
    t.datetime "trouble_start", null: false
    t.datetime "trouble_end"
    t.integer "checked_count"
    t.decimal "trouble_time", precision: 15, scale: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["server_id"], name: "index_troubles_on_server_id"
  end

  add_foreign_key "logs", "servers"
  add_foreign_key "troubles", "servers"
end
