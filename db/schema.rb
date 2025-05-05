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

ActiveRecord::Schema[7.0].define(version: 2025_04_23_172455) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sub_categories_count", default: 0, null: false
    t.bigint "priority_id", default: 3, null: false
    t.index ["priority_id"], name: "index_categories_on_priority_id"
  end

  create_table "check_list_groups", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_list_types", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_lists", force: :cascade do |t|
    t.bigint "division_id", null: false
    t.bigint "check_list_type_id", null: false
    t.bigint "author_id", default: 0, null: false
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_check_lists_on_author_id"
    t.index ["check_list_type_id"], name: "index_check_lists_on_check_list_type_id"
    t.index ["division_id"], name: "index_check_lists_on_division_id"
  end

  create_table "completed_missions", force: :cascade do |t|
    t.bigint "mission_executor_id", null: false
    t.text "description", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_executor_id"], name: "index_completed_missions_on_mission_executor_id"
  end

  create_table "completed_tasks", force: :cascade do |t|
    t.bigint "division_id", null: false
    t.bigint "user_id", null: false
    t.bigint "sub_category_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "time_start", null: false
    t.time "time_end", null: false
    t.integer "workload", default: 1
    t.index ["division_id"], name: "index_completed_tasks_on_division_id"
    t.index ["sub_category_id"], name: "index_completed_tasks_on_sub_category_id"
    t.index ["user_id"], name: "index_completed_tasks_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profiles_count", default: 0, null: false
    t.integer "sub_departments_count", default: 0, null: false
    t.integer "divisions_count", default: 0, null: false
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
    t.integer "completed_tasks_count", default: 0, null: false
    t.integer "tasks_count", default: 0, null: false
    t.index ["department_id"], name: "index_divisions_on_department_id"
  end

  create_table "list_events", force: :cascade do |t|
    t.bigint "check_list_id", null: false
    t.bigint "sub_check_list_id", null: false
    t.string "comment"
    t.integer "check_status", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_list_id"], name: "index_list_events_on_check_list_id"
    t.index ["sub_check_list_id"], name: "index_list_events_on_sub_check_list_id"
  end

  create_table "mission_approvals", force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.integer "mission_executor_id", null: false
    t.integer "coordinator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_mission_approvals_on_mission_id"
  end

  create_table "mission_executors", force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.bigint "executor_id", default: 0, null: false
    t.string "description", null: false
    t.integer "status", default: 0, null: false
    t.datetime "limit_at"
    t.datetime "close_at"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_executor_id", default: 0, null: false
    t.integer "coordinator_id", default: 0, null: false
    t.boolean "responsible", default: false
    t.index ["executor_id"], name: "index_mission_executors_on_executor_id"
    t.index ["mission_id"], name: "index_mission_executors_on_mission_id"
  end

  create_table "mission_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "missions_count", default: 0, null: false
    t.string "view_classing", default: "info"
  end

  create_table "missions", force: :cascade do |t|
    t.string "number", null: false
    t.integer "status", default: 1, null: false
    t.bigint "mission_type_id", null: false
    t.bigint "author_id", default: 0, null: false
    t.string "description", null: false
    t.bigint "control_executor_id", default: 0, null: false
    t.datetime "execution_limit_at"
    t.datetime "close_at"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mission_executors_count", default: 0, null: false
    t.bigint "division_id", default: 0
    t.index ["author_id"], name: "index_missions_on_author_id"
    t.index ["control_executor_id"], name: "index_missions_on_control_executor_id"
    t.index ["division_id"], name: "index_missions_on_division_id"
    t.index ["mission_type_id"], name: "index_missions_on_mission_type_id"
  end

  create_table "performed_works", force: :cascade do |t|
    t.bigint "sub_category_id", null: false
    t.bigint "task_id", null: false
    t.time "time_start", null: false
    t.time "time_end", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workload", default: 1
    t.index ["sub_category_id"], name: "index_performed_works_on_sub_category_id"
    t.index ["task_id"], name: "index_performed_works_on_task_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profiles_count", default: 0, null: false
  end

  create_table "priorities", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "limit_day", default: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tasks_count", default: 0, null: false
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
    t.integer "gender", default: 0, null: false
    t.string "telegram_id"
    t.index ["position_id"], name: "index_profiles_on_position_id"
    t.index ["sub_department_id"], name: "index_profiles_on_sub_department_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "related_missions", force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.integer "related", default: 0, null: false
    t.string "number_mission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_related_missions_on_mission_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "completed_tasks_count", default: 0, null: false
    t.integer "performed_works_count", default: 0, null: false
    t.boolean "workload", default: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "sub_check_lists", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "check_list_type_id", null: false
    t.bigint "check_list_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_list_group_id"], name: "index_sub_check_lists_on_check_list_group_id"
    t.index ["check_list_type_id"], name: "index_sub_check_lists_on_check_list_type_id"
  end

  create_table "sub_departments", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profiles_count", default: 0, null: false
    t.index ["department_id"], name: "index_sub_departments_on_department_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "division_id", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "description", null: false
    t.bigint "priority_id", default: 0, null: false
    t.bigint "executor_id", default: 0, null: false
    t.bigint "author_id", default: 0, null: false
    t.datetime "execution_limit_at", null: false
    t.datetime "close_at"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "performed_works_count", default: 0, null: false
    t.bigint "category_id", default: 1, null: false
    t.bigint "list_event_id"
    t.index ["author_id"], name: "index_tasks_on_author_id"
    t.index ["category_id"], name: "index_tasks_on_category_id"
    t.index ["division_id"], name: "index_tasks_on_division_id"
    t.index ["executor_id"], name: "index_tasks_on_executor_id"
    t.index ["list_event_id"], name: "index_tasks_on_list_event_id"
    t.index ["priority_id"], name: "index_tasks_on_priority_id"
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
    t.integer "completed_tasks_count", default: 0, null: false
    t.integer "author_tasks_count", default: 0, null: false
    t.integer "executor_tasks_count", default: 0, null: false
    t.integer "author_missions_count", default: 0, null: false
    t.integer "control_executor_missions_count", default: 0, null: false
    t.bigint "manager_id"
    t.integer "executor_missions_count", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["manager_id"], name: "index_users_on_manager_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "priorities"
  add_foreign_key "check_lists", "check_list_types"
  add_foreign_key "check_lists", "divisions"
  add_foreign_key "check_lists", "users", column: "author_id"
  add_foreign_key "completed_missions", "mission_executors"
  add_foreign_key "completed_tasks", "divisions"
  add_foreign_key "completed_tasks", "sub_categories"
  add_foreign_key "completed_tasks", "users"
  add_foreign_key "divisions", "departments"
  add_foreign_key "list_events", "check_lists"
  add_foreign_key "list_events", "sub_check_lists"
  add_foreign_key "mission_approvals", "missions"
  add_foreign_key "mission_executors", "missions"
  add_foreign_key "mission_executors", "users", column: "executor_id"
  add_foreign_key "missions", "divisions"
  add_foreign_key "missions", "mission_types"
  add_foreign_key "missions", "users", column: "author_id"
  add_foreign_key "missions", "users", column: "control_executor_id"
  add_foreign_key "performed_works", "sub_categories"
  add_foreign_key "performed_works", "tasks"
  add_foreign_key "profiles", "positions"
  add_foreign_key "profiles", "sub_departments"
  add_foreign_key "profiles", "users"
  add_foreign_key "related_missions", "missions"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "sub_check_lists", "check_list_groups"
  add_foreign_key "sub_check_lists", "check_list_types"
  add_foreign_key "sub_departments", "departments"
  add_foreign_key "tasks", "categories"
  add_foreign_key "tasks", "divisions"
  add_foreign_key "tasks", "list_events"
  add_foreign_key "tasks", "priorities"
  add_foreign_key "tasks", "users", column: "author_id"
  add_foreign_key "tasks", "users", column: "executor_id"
  add_foreign_key "users", "users", column: "manager_id"
end
