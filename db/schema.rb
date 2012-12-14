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

ActiveRecord::Schema.define(:version => 20121213073752) do

  create_table "e_books", :force => true do |t|
    t.string   "name"
    t.string   "language"
    t.string   "author"
    t.string   "publisher"
    t.string   "format"
    t.string   "image_large"
    t.string   "image_small"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "publish_year"
    t.string   "programming_language"
  end

  create_table "webstorage_links", :force => true do |t|
    t.integer  "e_book_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
