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

ActiveRecord::Schema.define(version: 20170624191621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brackets", force: :cascade do |t|
    t.integer "championship_id"
    t.integer "player_1_id"
    t.integer "player_2_id"
    t.integer "winner_id"
    t.integer "parent_id"
    t.index ["championship_id"], name: "index_brackets_on_championship_id", using: :btree
    t.index ["parent_id"], name: "index_brackets_on_parent_id", using: :btree
    t.index ["player_1_id"], name: "index_brackets_on_player_1_id", using: :btree
    t.index ["player_2_id"], name: "index_brackets_on_player_2_id", using: :btree
    t.index ["winner_id"], name: "index_brackets_on_winner_id", using: :btree
  end

  create_table "championship_types", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "championships", force: :cascade do |t|
    t.string  "name"
    t.string  "game"
    t.integer "user_id"
    t.date    "starts_at"
    t.date    "ends_at"
    t.integer "championship_type_id"
    t.integer "winner"
    t.index ["championship_type_id"], name: "index_championships_on_championship_type_id", using: :btree
    t.index ["user_id"], name: "index_championships_on_user_id", using: :btree
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "championship_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["championship_id"], name: "index_participants_on_championship_id", using: :btree
    t.index ["user_id"], name: "index_participants_on_user_id", using: :btree
  end

  create_table "pontoscorridos_partidas", force: :cascade do |t|
    t.integer  "championship_id"
    t.integer  "player1"
    t.integer  "player2"
    t.integer  "score_player1"
    t.integer  "score_player2"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "finished"
    t.index ["championship_id"], name: "index_pontoscorridos_partidas_on_championship_id", using: :btree
  end

  create_table "rankings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "played_games"
    t.integer  "scheduled_games"
    t.integer  "victories"
    t.integer  "draws"
    t.integer  "defeats"
    t.integer  "points"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "position"
    t.integer  "wins"
    t.index ["user_id"], name: "index_rankings_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "link_photo"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "championships", "championship_types"
  add_foreign_key "participants", "championships"
  add_foreign_key "participants", "users"
  add_foreign_key "pontoscorridos_partidas", "championships"
  add_foreign_key "rankings", "users"
end
