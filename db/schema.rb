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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161022152051) do

  create_table "article_entities", force: :cascade do |t|
    t.integer "article_id", null: false
    t.integer "entity_id",  null: false
  end

  add_index "article_entities", ["article_id"], name: "index_article_entities_on_article_id"
  add_index "article_entities", ["entity_id"], name: "index_article_entities_on_entity_id"

  create_table "article_graph_vertices", force: :cascade do |t|
    t.integer "article_1_id", null: false
    t.integer "article_2_id", null: false
    t.float   "weight",       null: false
  end

  add_index "article_graph_vertices", ["article_1_id"], name: "index_article_graph_vertices_on_article_1_id"
  add_index "article_graph_vertices", ["article_2_id"], name: "index_article_graph_vertices_on_article_2_id"

  create_table "articles", force: :cascade do |t|
    t.integer  "source_id",                                    null: false
    t.string   "title",                                        null: false
    t.text     "summary"
    t.datetime "published_at",                                 null: false
    t.text     "uid",                                          null: false
    t.string   "url"
    t.text     "raw"
    t.datetime "created_at",   default: '2016-10-11 07:29:47', null: false
  end

  add_index "articles", ["source_id"], name: "index_articles_on_source_id"

  create_table "biases", force: :cascade do |t|
    t.integer "industry_id", null: false
    t.string  "name",        null: false
    t.text    "description"
    t.string  "from_colour", null: false
    t.string  "to_colour",   null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "entities", force: :cascade do |t|
    t.integer "industry_id",                 null: false
    t.string  "entity",                      null: false
    t.integer "importance",  default: 0,     null: false
    t.boolean "is_compound", default: false, null: false
  end

  add_index "entities", ["entity"], name: "index_entities_on_entity"
  add_index "entities", ["importance"], name: "index_entities_on_importance"
  add_index "entities", ["industry_id"], name: "index_entities_on_industry_id"

  create_table "industries", force: :cascade do |t|
    t.string "name",        null: false
    t.text   "description"
  end

  create_table "source_bias_levels", force: :cascade do |t|
    t.integer "source_id", null: false
    t.integer "bias_id",   null: false
    t.integer "level",     null: false
  end

  create_table "sources", force: :cascade do |t|
    t.integer  "industry_id",                 null: false
    t.string   "name",                        null: false
    t.text     "svg_icon"
    t.string   "colour",                      null: false
    t.string   "rss_url",                     null: false
    t.datetime "last_fetched"
    t.string   "svg_bg"
    t.boolean  "enabled",      default: true, null: false
  end

  create_table "topic_rules", force: :cascade do |t|
    t.integer  "topic_id",                   null: false
    t.integer  "logic",          default: 0, null: false
    t.integer  "value_integer"
    t.datetime "value_datetime"
    t.string   "value_string"
  end

  create_table "topics", force: :cascade do |t|
    t.integer "industry_id", null: false
    t.string  "name",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_enabled",             default: true,  null: false
    t.boolean  "is_admin",               default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
