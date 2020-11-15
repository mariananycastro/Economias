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

ActiveRecord::Schema.define(version: 2020_11_15_153956) do

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

  create_table "installment_simple_movements", force: :cascade do |t|
    t.bigint "installment_id", null: false
    t.bigint "simple_movement_id", null: false
    t.index ["installment_id"], name: "index_installment_simple_movements_on_installment_id"
    t.index ["simple_movement_id"], name: "index_installment_simple_movements_on_simple_movement_id"
  end

  create_table "installments", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "movements", force: :cascade do |t|
    t.string "name"
    t.decimal "value"
    t.date "date"
    t.integer "movement_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "category_id"
    t.index ["account_id"], name: "index_movements_on_account_id"
    t.index ["category_id"], name: "index_movements_on_category_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "origin_id"
    t.bigint "destiny_id"
    t.index ["destiny_id"], name: "index_transfers_on_destiny_id"
    t.index ["origin_id"], name: "index_transfers_on_origin_id"
  end

  add_foreign_key "accounts", "account_types"
  add_foreign_key "installment_simple_movements", "installments"
  add_foreign_key "installment_simple_movements", "movements", column: "simple_movement_id"
  add_foreign_key "movements", "accounts"
  add_foreign_key "movements", "categories"
end
