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

ActiveRecord::Schema[7.0].define(version: 2022_10_22_175949) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "completed_tasks", force: :cascade do |t|
    t.bigint "division_id", null: false
    t.bigint "user_id", null: false
    t.bigint "sub_category_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_completed_tasks_on_division_id"
    t.index ["sub_category_id"], name: "index_completed_tasks_on_sub_category_id"
    t.index ["user_id"], name: "index_completed_tasks_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "department_id", null: false
    t.string "address", default: "", null: false
    t.string "email"
    t.string "photo"
    t.float "latitude", default: 0.0, null: false
    t.float "longitude", default: 0.0, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_divisions_on_department_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "avatar"
    t.string "mobile"
    t.bigint "user_id", null: false
    t.bigint "sub_department_id", null: false
    t.bigint "position_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_id"], name: "index_profiles_on_position_id"
    t.index ["sub_department_id"], name: "index_profiles_on_sub_department_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "sub_departments", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_sub_departments_on_department_id"
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

  add_foreign_key "completed_tasks", "divisions"
  add_foreign_key "completed_tasks", "sub_categories"
  add_foreign_key "completed_tasks", "users"
  add_foreign_key "divisions", "departments"
  add_foreign_key "profiles", "positions"
  add_foreign_key "profiles", "sub_departments"
  add_foreign_key "profiles", "users"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "sub_departments", "departments"
end
