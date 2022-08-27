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

ActiveRecord::Schema.define(version: 2022_08_27_160902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "erp_data_sync_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "application_name"
    t.jsonb "payload"
    t.bigint "original_entity_id"
    t.uuid "original_event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["original_entity_id"], name: "index_erp_data_sync_events_on_original_entity_id"
  end

end
