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

ActiveRecord::Schema.define(:version => 20101118005343) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "guild_id"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "character_id",                :null => false
    t.integer  "raid_id",                     :null => false
    t.string   "role",                        :null => false
    t.integer  "status",       :default => 1, :null => false
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.integer  "guild_id"
    t.integer  "user_id"
    t.string   "name",                                                :null => false
    t.integer  "rank"
    t.integer  "level"
    t.boolean  "online",                           :default => false, :null => false
    t.datetime "last_seen"
    t.integer  "activity",                         :default => 0,     :null => false
    t.integer  "class_id"
    t.integer  "race_id"
    t.integer  "faction_id"
    t.integer  "gender_id"
    t.integer  "achivementpoints"
    t.integer  "ail"
    t.string   "talentspec1"
    t.string   "talentspec2"
    t.string   "profession1"
    t.string   "profession2"
    t.boolean  "main",                             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "items",            :limit => 2000
    t.integer  "ailstddev"
    t.string   "realm",                                               :null => false
    t.datetime "last_sync"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "action",                         :null => false
    t.string   "content"
    t.integer  "guild_id"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",      :default => true
  end

  create_table "guilds", :force => true do |t|
    t.string   "name",                                 :null => false
    t.integer  "rating"
    t.string   "token",                                :null => false
    t.string   "website"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "realm",                                :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "recruit_text"
    t.boolean  "recruit_open",      :default => false
    t.boolean  "recruit_dk",        :default => false
    t.boolean  "recruit_druid",     :default => false
    t.boolean  "recruit_hunter",    :default => false
    t.boolean  "recruit_mage",      :default => false
    t.boolean  "recruit_paladin",   :default => false
    t.boolean  "recruit_priest",    :default => false
    t.boolean  "recruit_rogue",     :default => false
    t.boolean  "recruit_shaman",    :default => false
    t.boolean  "recruit_warlock",   :default => false
    t.boolean  "recruit_warrior",   :default => false
    t.boolean  "recruit_healer",    :default => false
    t.boolean  "recruit_damage",    :default => false
    t.boolean  "recruit_tank",      :default => false
    t.boolean  "verified"
    t.integer  "recruit_level"
    t.integer  "faction_id"
    t.datetime "last_sync"
    t.string   "teamspeak"
  end

  create_table "guilds_raids", :id => false, :force => true do |t|
    t.integer "guild_id"
    t.integer "raid_id"
  end

  create_table "newsentries", :force => true do |t|
    t.string   "title",                         :null => false
    t.integer  "user_id",                       :null => false
    t.text     "body",                          :null => false
    t.boolean  "public",     :default => false, :null => false
    t.boolean  "sticky",     :default => false, :null => false
    t.integer  "guild_id",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raids", :force => true do |t|
    t.integer  "guild_id",                         :null => false
    t.string   "title",                            :null => false
    t.integer  "max_attendees", :default => 25
    t.datetime "invite_start"
    t.datetime "start",                            :null => false
    t.datetime "end"
    t.text     "description"
    t.integer  "leader"
    t.boolean  "closed",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_lvl"
    t.integer  "min_lvl"
    t.string   "icon"
    t.string   "limit_roles"
    t.string   "limit_classes"
    t.boolean  "autoconfirm",   :default => false
  end

  create_table "remote_queries", :force => true do |t|
    t.integer  "priority",     :null => false
    t.integer  "efford",       :null => false
    t.string   "action",       :null => false
    t.integer  "character_id"
    t.integer  "guild_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",               :default => false, :null => false
    t.boolean  "active",              :default => false, :null => false
    t.string   "language"
    t.string   "icq"
    t.string   "msn"
    t.string   "skype"
    t.string   "jabber"
    t.text     "signature"
  end

end
