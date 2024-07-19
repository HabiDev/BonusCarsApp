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

ActiveRecord::Schema[7.0].define(version: 2024_07_19_070401) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "owner_card", default: "", null: false
    t.string "code_card", null: false
    t.datetime "release_at", null: false
    t.integer "default_charge_sum", default: 0
    t.float "balance", default: 0.0
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code_card"], name: "index_cards_on_code_card", unique: true
    t.index ["owner_card"], name: "index_cards_on_owner_card", unique: true
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "avatar"
    t.string "mobile"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "statements", force: :cascade do |t|
    t.string "item", default: "0", null: false
    t.bigint "division_id", null: false
    t.decimal "ammount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_statements_on_division_id"
  end

  create_table "sub_statements", force: :cascade do |t|
    t.bigint "statement_id", null: false
    t.bigint "card_id", null: false
    t.integer "charge_sum", default: 0, null: false
    t.string "balance_before", default: "0.00"
    t.string "balance_after", default: "0.00"
    t.integer "status", default: 0, null: false
    t.string "error_text"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_sub_statements_on_card_id"
    t.index ["statement_id"], name: "index_sub_statements_on_statement_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "type_role", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "profiles", "users"
  add_foreign_key "statements", "divisions"
  add_foreign_key "sub_statements", "cards"
  add_foreign_key "sub_statements", "statements"
end
