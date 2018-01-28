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

ActiveRecord::Schema.define(version: 20180125225253) do

  create_table "item_mods", force: :cascade do |t|
    t.integer "mod_id"
    t.integer "unique_id"
    t.string "min_value"
    t.string "max_value"
    t.boolean "implicit", default: false
    t.boolean "hidden", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mod_id"], name: "index_item_mods_on_mod_id"
    t.index ["unique_id"], name: "index_item_mods_on_unique_id"
  end

  create_table "mods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uniques", force: :cascade do |t|
    t.string "name"
    t.string "base_name"
    t.string "type"
    t.integer "required_int"
    t.integer "required_dex"
    t.integer "required_str"
    t.integer "level_requirement"
    t.integer "block_chance"
    t.integer "min_armour"
    t.integer "max_armour"
    t.integer "min_evasion"
    t.integer "max_evasion"
    t.integer "min_energy_shield"
    t.integer "max_energy_shield"
    t.integer "map_tier"
    t.integer "jewel_radius"
    t.integer "jewel_limit"
    t.integer "flask_min_life"
    t.integer "flask_max_life"
    t.integer "flask_min_mana"
    t.integer "flask_max_mana"
    t.float "flask_min_duration"
    t.float "flask_max_duration"
    t.integer "flask_min_usage"
    t.integer "flask_max_usage"
    t.string "flask_buff_effect"
    t.float "min_total_dps"
    t.float "max_total_dps"
    t.float "min_phys_dps"
    t.float "max_phys_dps"
    t.float "min_chaos_dps"
    t.float "max_chaos_dps"
    t.float "min_ele_dps"
    t.float "max_ele_dps"
    t.float "critical_strike_chance"
    t.float "aps"
    t.integer "quality"
    t.string "image_url"
    t.string "version"
    t.text "flavor_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
