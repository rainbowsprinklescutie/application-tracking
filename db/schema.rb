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

ActiveRecord::Schema[8.0].define(version: 2024_12_23_000004) do
  create_table "application_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_application_statuses_on_name", unique: true
  end

  create_table "job_applications", force: :cascade do |t|
    t.date "date_applied", null: false
    t.string "company_name", null: false
    t.string "job_link", null: false
    t.text "tech_stacks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "application_status_id", default: 1, null: false
    t.index ["application_status_id"], name: "index_job_applications_on_application_status_id"
    t.index ["company_name"], name: "index_job_applications_on_company_name"
    t.index ["date_applied"], name: "index_job_applications_on_date_applied"
  end

  create_table "job_applications_tech_stacks", id: false, force: :cascade do |t|
    t.integer "job_application_id", null: false
    t.integer "tech_stack_id", null: false
    t.index ["job_application_id", "tech_stack_id"], name: "index_job_applications_tech_stacks_unique", unique: true
    t.index ["job_application_id"], name: "index_job_applications_tech_stacks_on_job_application_id"
    t.index ["tech_stack_id"], name: "index_job_applications_tech_stacks_on_tech_stack_id"
  end

  create_table "tech_stacks", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tech_stacks_on_name", unique: true
  end

  add_foreign_key "job_applications", "application_statuses"
  add_foreign_key "job_applications_tech_stacks", "job_applications"
  add_foreign_key "job_applications_tech_stacks", "tech_stacks"
end
