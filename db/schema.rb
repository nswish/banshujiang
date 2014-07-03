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

ActiveRecord::Schema.define(:version => 20140703034619) do

  create_table "attrs", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "donations", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",     :precision => 6, :scale => 2
    t.string   "date"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "download_priviledges", :force => true do |t|
    t.integer  "e_book_id"
    t.integer  "user_id"
    t.datetime "expiration_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "e_book_attrs", :force => true do |t|
    t.integer  "e_book_id"
    t.integer  "attr_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "e_books", :force => true do |t|
    t.string   "name"
    t.string   "language"
    t.string   "author"
    t.string   "format"
    t.string   "image_large"
    t.string   "image_small"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "publish_year"
    t.integer  "download_count"
    t.integer  "list_id"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ip_downloads", :force => true do |t|
    t.string   "ip"
    t.integer  "e_book_id"
    t.string   "e_book_name"
    t.string   "location"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "isp"
  end

  create_table "lists", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "login_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "search_words", :force => true do |t|
    t.string   "content"
    t.integer  "search_count"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "password"
    t.string   "ip"
    t.string   "age"
    t.integer  "score"
    t.string   "kind"
    t.string   "password_hash"
    t.string   "reset_token"
  end

  create_table "value_set_bodies", :force => true do |t|
    t.integer  "value_set_header_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "value_set_headers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "title"
    t.boolean  "is_category"
    t.integer  "attr_id"
  end

  create_table "webstorage_links", :force => true do |t|
    t.integer  "e_book_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ad_link"
    t.string   "secret_key"
  end

end
