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

ActiveRecord::Schema.define(version: 20161112102709) do

  create_table "accounts", force: :cascade do |t|
    t.decimal  "balance",    precision: 5, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "auctions", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "starting_price", precision: 5, scale: 2
    t.decimal  "buyout_price",   precision: 5, scale: 2
    t.string   "state"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["user_id"], name: "index_auctions_on_user_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount",     precision: 5, scale: 2
    t.integer  "auction_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["auction_id"], name: "index_bids_on_auction_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "condition"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "auction_id"
    t.index ["auction_id"], name: "index_items_on_auction_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "tel_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "account_id"
    t.index ["account_id"], name: "index_users_on_account_id"
  end

end
