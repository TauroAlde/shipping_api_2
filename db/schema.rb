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

ActiveRecord::Schema[8.1].define(version: 2026_03_22_022732) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "quotation_results", force: :cascade do |t|
    t.string "carrier", null: false
    t.datetime "created_at", null: false
    t.string "currency"
    t.integer "days"
    t.decimal "price", precision: 10, scale: 2
    t.bigint "quotation_id", null: false
    t.jsonb "raw_response"
    t.float "reliability"
    t.float "score"
    t.string "service"
    t.datetime "updated_at", null: false
    t.index ["carrier"], name: "index_quotation_results_on_carrier"
    t.index ["quotation_id"], name: "index_quotation_results_on_quotation_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipment_events", force: :cascade do |t|
    t.string "carrier"
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.bigint "shipment_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["shipment_id"], name: "index_shipment_events_on_shipment_id"
  end

  create_table "shipment_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipment_stats", force: :cascade do |t|
    t.float "avg_days"
    t.string "carrier"
    t.datetime "created_at", null: false
    t.integer "deliveries"
    t.integer "failures"
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

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "quotation_results", "quotations"
  add_foreign_key "shipment_events", "shipments"
end
