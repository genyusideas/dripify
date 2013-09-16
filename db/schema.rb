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

ActiveRecord::Schema.define(:version => 20130904023712) do

  create_table "drip_marketing_campaigns", :force => true do |t|
    t.boolean  "active",                  :default => true
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "social_media_account_id"
  end

  add_index "drip_marketing_campaigns", ["social_media_account_id"], :name => "index_drip_marketing_campaigns_on_social_media_account_id"

  create_table "drip_marketing_rules", :force => true do |t|
    t.integer  "delay"
    t.text     "message"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "drip_marketing_campaign_id"
  end

  add_index "drip_marketing_rules", ["drip_marketing_campaign_id"], :name => "index_drip_marketing_rules_on_drip_marketing_campaign_id"

  create_table "friend_relationships", :force => true do |t|
    t.integer  "followed_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_new",      :default => true
    t.string   "follower_id"
  end

  create_table "social_media_accounts", :force => true do |t|
    t.string   "type"
    t.string   "handle"
    t.string   "handle_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "token"
    t.string   "secret"
    t.string   "profile_image_url"
  end

  add_index "social_media_accounts", ["handle_id"], :name => "index_social_media_accounts_on_handle_id", :unique => true
  add_index "social_media_accounts", ["user_id"], :name => "index_social_media_accounts_on_user_id"

  create_table "twitter_messages", :force => true do |t|
    t.integer  "twitter_account_id"
    t.integer  "recipient_id"
    t.text     "message"
    t.string   "status"
    t.datetime "send_date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
