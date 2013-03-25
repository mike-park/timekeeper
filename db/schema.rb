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

ActiveRecord::Schema.define(:version => 20130324133439) do

  create_table "activities", :force => true do |t|
    t.integer   "trackable_id"
    t.string    "trackable_type"
    t.integer   "owner_id"
    t.string    "owner_type"
    t.string    "key"
    t.text      "parameters"
    t.integer   "recipient_id"
    t.string    "recipient_type"
    t.timestamp "created_at",     :null => false
    t.timestamp "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "bill_items", :force => true do |t|
    t.decimal   "price",      :default => 0.0
    t.integer   "bill_id"
    t.integer   "client_id"
    t.integer   "event_id"
    t.timestamp "created_at",                  :null => false
    t.timestamp "updated_at",                  :null => false
  end

  add_index "bill_items", ["bill_id"], :name => "index_bill_items_on_bill_id"
  add_index "bill_items", ["client_id"], :name => "index_bill_items_on_client_id"
  add_index "bill_items", ["event_id"], :name => "index_bill_items_on_event_id"

  create_table "bills", :force => true do |t|
    t.date      "billed_on"
    t.integer   "therapist_id"
    t.string    "number"
    t.timestamp "created_at",     :null => false
    t.timestamp "updated_at",     :null => false
    t.integer   "praxis_bill_id"
  end

  add_index "bills", ["praxis_bill_id"], :name => "index_bills_on_praxis_bill_id"
  add_index "bills", ["therapist_id"], :name => "index_bills_on_therapist_id"

  create_table "clients", :force => true do |t|
    t.string    "first_name"
    t.string    "last_name"
    t.date      "dob"
    t.timestamp "created_at",                    :null => false
    t.timestamp "updated_at",                    :null => false
    t.string    "fingerprint"
    t.string    "full_name"
    t.boolean   "active",      :default => true
  end

  add_index "clients", ["fingerprint"], :name => "index_clients_on_fingerprint"
  add_index "clients", ["last_name", "first_name"], :name => "index_clients_on_last_name_and_first_name"

  create_table "event_categories", :force => true do |t|
    t.string    "title"
    t.string    "abbrv"
    t.integer   "sort_order"
    t.string    "color"
    t.timestamp "created_at",                   :null => false
    t.timestamp "updated_at",                   :null => false
    t.boolean   "active",     :default => true
  end

  create_table "event_category_prices", :force => true do |t|
    t.string    "title"
    t.decimal   "price"
    t.integer   "event_category_id"
    t.timestamp "created_at",        :null => false
    t.timestamp "updated_at",        :null => false
  end

  add_index "event_category_prices", ["event_category_id"], :name => "index_event_category_prices_on_event_category_id"

  create_table "events", :force => true do |t|
    t.integer   "therapist_id"
    t.integer   "event_category_id"
    t.integer   "user_id"
    t.date      "occurred_on"
    t.integer   "client_id"
    t.timestamp "created_at",        :null => false
    t.timestamp "updated_at",        :null => false
    t.integer   "bill_id"
  end

  add_index "events", ["bill_id"], :name => "index_events_on_bill_id"
  add_index "events", ["client_id"], :name => "index_events_on_client_id"
  add_index "events", ["event_category_id"], :name => "index_events_on_event_category_id"
  add_index "events", ["therapist_id"], :name => "index_events_on_therapist_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "praxis_bills", :force => true do |t|
    t.date      "billed_on"
    t.string    "number"
    t.text      "note"
    t.integer   "user_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "praxis_bills", ["billed_on"], :name => "index_praxis_bills_on_billed_on"
  add_index "praxis_bills", ["user_id"], :name => "index_praxis_bills_on_user_id"

  create_table "roles", :force => true do |t|
    t.string    "name"
    t.integer   "resource_id"
    t.string    "resource_type"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "taggings", :force => true do |t|
    t.integer   "tag_id"
    t.integer   "taggable_id"
    t.string    "taggable_type"
    t.integer   "tagger_id"
    t.string    "tagger_type"
    t.string    "context",       :limit => 128
    t.timestamp "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "therapists", :force => true do |t|
    t.string    "first_name"
    t.string    "last_name"
    t.string    "abbrv"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.string    "category"
    t.string    "full_name"
    t.text      "options"
  end

  create_table "torgs", :force => true do |t|
    t.date      "start_date"
    t.date      "end_date"
    t.text      "report"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "torgs", ["start_date", "end_date"], :name => "index_torgs_on_start_date_and_end_date"

  create_table "users", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
    t.string    "name"
    t.integer   "therapist_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
