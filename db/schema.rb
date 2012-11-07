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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121107054614) do

  create_table "act_photo_relas", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "photo_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "act_photo_relas", ["activity_id", "photo_id"], :name => "index_act_photo_relas_on_activity_id_and_photo_id", :unique => true
  add_index "act_photo_relas", ["activity_id"], :name => "index_act_photo_relas_on_activity_id"
  add_index "act_photo_relas", ["photo_id"], :name => "index_act_photo_relas_on_photo_id"

  create_table "act_tag_relas", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "tag_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "act_tag_relas", ["activity_id", "tag_id"], :name => "index_act_tag_relas_on_activity_id_and_tag_id", :unique => true
  add_index "act_tag_relas", ["activity_id"], :name => "index_act_tag_relas_on_activity_id"
  add_index "act_tag_relas", ["tag_id"], :name => "index_act_tag_relas_on_tag_id"

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string   "content"
    t.string   "GUID"
    t.string   "GUID_created_at"
    t.string   "back_up"
    t.integer  "state",           :default => 0, :null => false
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "pcount"
  end

  add_index "activities", ["user_id", "created_at"], :name => "index_activities_on_user_id_and_created_at"

  create_table "addresses", :force => true do |t|
    t.string   "addressLine"
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "activity_id"
  end

  create_table "interest_tag_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "interest_tag_records", ["tag_id"], :name => "index_interest_tag_records_on_tag_id"
  add_index "interest_tag_records", ["user_id", "tag_id"], :name => "index_interest_tag_records_on_user_id_and_tag_id"
  add_index "interest_tag_records", ["user_id"], :name => "index_interest_tag_records_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "activity_id"
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "activity_id"
  end

  add_index "photos", ["activity_id"], :name => "index_photos_on_activity_id"
  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "signed_addresses", :force => true do |t|
    t.float    "lat"
    t.float    "lng"
    t.integer  "user_id"
    t.integer  "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_ac_relas", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_ac_relas", ["activity_id"], :name => "index_user_ac_relas_on_activity_id"
  add_index "user_ac_relas", ["user_id", "activity_id"], :name => "index_user_ac_relas_on_user_id_and_activity_id", :unique => true
  add_index "user_ac_relas", ["user_id"], :name => "index_user_ac_relas_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",              :default => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
