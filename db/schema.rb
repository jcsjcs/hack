# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130923113333) do

  create_table "hack_attendances", force: true do |t|
    t.integer  "hack_meet_id"
    t.integer  "hack_member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hack_attendances", ["hack_meet_id"], name: "index_hack_attendances_on_hack_meet_id", using: :btree
  add_index "hack_attendances", ["hack_member_id"], name: "index_hack_attendances_on_hack_member_id", using: :btree

  create_table "hack_meets", force: true do |t|
    t.integer  "hack_year",                               null: false
    t.integer  "hack_month",                              null: false
    t.date     "hack_date",                               null: false
    t.string   "start_time",             default: "8:00", null: false
    t.string   "work_area"
    t.text     "notes"
    t.integer  "hack_venue_id",                           null: false
    t.boolean  "social",                 default: false
    t.integer  "hack_attendances_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hack_meets", ["hack_venue_id"], name: "index_hack_meets_on_hack_venue_id", using: :btree

  create_table "hack_meets_plant_types", id: false, force: true do |t|
    t.integer "hack_meet_id",  null: false
    t.integer "plant_type_id", null: false
  end

  add_index "hack_meets_plant_types", ["plant_type_id", "hack_meet_id"], name: "index_hack_meets_plant_types_on_plant_type_id_and_hack_meet_id", unique: true, using: :btree

  create_table "hack_members", force: true do |t|
    t.string   "title"
    t.string   "initials"
    t.string   "first_name"
    t.string   "surname"
    t.string   "tel_home"
    t.string   "tel_office"
    t.string   "tel_cell"
    t.string   "email"
    t.boolean  "email_ok",               default: true
    t.string   "email_issues"
    t.boolean  "non_hacker",             default: false
    t.text     "comments"
    t.integer  "contact_via"
    t.integer  "group_with"
    t.integer  "hack_attendances_count", default: 0
    t.integer  "integer",                default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hack_venues", force: true do |t|
    t.string   "venue"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plant_types", force: true do |t|
    t.string   "name",       null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
