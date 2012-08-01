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

ActiveRecord::Schema.define(:version => 20120801065728) do

  create_table "options", :force => true do |t|
    t.integer  "poll_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["poll_id"], :name => "index_options_on_poll_id"

  create_table "polls", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.boolean  "closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.text     "desc"
    t.string   "short_link"
    t.boolean  "anon",       :default => false, :null => false
  end

  add_index "polls", ["id"], :name => "poll_id_desc"
  add_index "polls", ["key"], :name => "index_polls_on_key"
  add_index "polls", ["user_id"], :name => "index_polls_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "votes", :force => true do |t|
    t.integer  "option_id"
    t.integer  "user_id"
    t.boolean  "yes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["option_id"], :name => "index_votes_on_option_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
