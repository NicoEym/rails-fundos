# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_05_194246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "anbima_classes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applications", force: :cascade do |t|
    t.bigint "fund_id"
    t.bigint "calendar_id"
    t.float "weekly_net_value"
    t.float "monthly_net_value"
    t.float "quarterly_net_value"
    t.float "yearly_net_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_applications_on_calendar_id"
    t.index ["fund_id"], name: "index_applications_on_fund_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aums", force: :cascade do |t|
    t.float "value"
    t.bigint "fund_id"
    t.bigint "calendar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_aums_on_calendar_id"
    t.index ["fund_id"], name: "index_aums_on_fund_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.date "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.integer "codigo_economatica"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gestor_id"
    t.bigint "anbima_class_id"
    t.bigint "area_id"
    t.string "competitor_group"
    t.index ["anbima_class_id"], name: "index_funds_on_anbima_class_id"
    t.index ["area_id"], name: "index_funds_on_area_id"
    t.index ["gestor_id"], name: "index_funds_on_gestor_id"
  end

  create_table "gestors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "indicators", force: :cascade do |t|
    t.bigint "fund_id"
    t.bigint "calendar_id"
    t.float "volatility"
    t.float "tracking_error"
    t.float "sharpe_ratio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_indicators_on_calendar_id"
    t.index ["fund_id"], name: "index_indicators_on_fund_id"
  end

  create_table "returns", force: :cascade do |t|
    t.bigint "fund_id"
    t.bigint "calendar_id"
    t.float "daily_value"
    t.float "weekly_value"
    t.float "monthly_value"
    t.float "quarterly_value"
    t.float "yearly_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_returns_on_calendar_id"
    t.index ["fund_id"], name: "index_returns_on_fund_id"
  end

  create_table "shares", force: :cascade do |t|
    t.float "value"
    t.bigint "fund_id"
    t.bigint "calendar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_shares_on_calendar_id"
    t.index ["fund_id"], name: "index_shares_on_fund_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applications", "calendars"
  add_foreign_key "applications", "funds"
  add_foreign_key "aums", "calendars"
  add_foreign_key "aums", "funds"
  add_foreign_key "funds", "anbima_classes"
  add_foreign_key "funds", "areas"
  add_foreign_key "funds", "gestors"
  add_foreign_key "indicators", "calendars"
  add_foreign_key "indicators", "funds"
  add_foreign_key "returns", "calendars"
  add_foreign_key "returns", "funds"
  add_foreign_key "shares", "calendars"
  add_foreign_key "shares", "funds"
end
