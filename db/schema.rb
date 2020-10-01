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

ActiveRecord::Schema.define(version: 2020_09_29_202058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.decimal "initial_value", default: "0.0"
    t.bigint "account_type_id"
    t.integer "expiration_type", default: 0
    t.index ["account_type_id"], name: "index_accounts_on_account_type_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "name"
    t.decimal "value"
    t.date "date"
    t.integer "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "category_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  add_foreign_key "accounts", "account_types"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
end
