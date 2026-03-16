# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_16_203033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "quotation_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipment_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade do |t|
    t.string "carrier"
    t.datetime "created_at", null: false
    t.string "label_url"
    t.jsonb "metadata"
    t.string "payment_status"
    t.string "rate_id"
    t.string "service_id"
    t.string "skydropx_id"
    t.decimal "total"
    t.string "tracking_number"
    t.string "tracking_status"
    t.string "tracking_url"
    t.datetime "updated_at", null: false
    t.string "workflow_status"
    t.index ["skydropx_id"], name: "index_shipments_on_skydropx_id"
  end
end
