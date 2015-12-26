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

ActiveRecord::Schema.define(version: 20151225123843) do

  create_table "account_balance_distributions", force: :cascade do |t|
    t.integer  "account_balance_id", limit: 4
    t.integer  "debt_id",            limit: 4
    t.decimal  "recommendation",               precision: 8, scale: 2, null: false
    t.decimal  "actual",                       precision: 8, scale: 2, null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "account_balance_distributions", ["account_balance_id"], name: "index_account_balance_distributions_on_account_balance_id", using: :btree
  add_index "account_balance_distributions", ["debt_id"], name: "index_account_balance_distributions_on_debt_id", using: :btree

  create_table "account_balances", force: :cascade do |t|
    t.date     "balance_date",                                   null: false
    t.integer  "account_id",   limit: 4
    t.decimal  "amount",                 precision: 8, scale: 2, null: false
    t.decimal  "buffer",                 precision: 8, scale: 2, null: false
    t.integer  "debt_id",      limit: 4
    t.boolean  "paid"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "account_balances", ["account_id"], name: "index_account_balances_on_account_id", using: :btree
  add_index "account_balances", ["debt_id"], name: "index_account_balances_on_debt_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id",      limit: 4,  null: false
    t.string   "name",         limit: 20
    t.string   "account_type", limit: 20
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "accounts", ["user_id", "name"], name: "by_user_name", unique: true, using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "budgets", force: :cascade do |t|
    t.integer  "category_id",  limit: 4
    t.date     "budget_month",                                   null: false
    t.decimal  "amount",                 precision: 8, scale: 2, null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "budgets", ["category_id", "budget_month"], name: "by_category_month", unique: true, using: :btree
  add_index "budgets", ["category_id"], name: "index_budgets_on_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  add_index "categories", ["user_id", "name"], name: "by_user_name", unique: true, using: :btree
  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "debt_balances", force: :cascade do |t|
    t.integer  "debt_id",            limit: 4
    t.date     "due_date",                                                            null: false
    t.decimal  "balance",                      precision: 10, scale: 2,               null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.date     "payment_start_date"
    t.decimal  "target_balance",               precision: 10, scale: 2, default: 0.0, null: false
  end

  add_index "debt_balances", ["debt_id", "due_date"], name: "by_debt_due_date", unique: true, using: :btree
  add_index "debt_balances", ["debt_id"], name: "index_debt_balances_on_debt_id", using: :btree
  add_index "debt_balances", ["payment_start_date"], name: "index_debt_balances_on_payment_start_date", using: :btree

  create_table "debts", force: :cascade do |t|
    t.string   "sub_category",       limit: 255,                                          null: false
    t.string   "name",               limit: 255,                                          null: false
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.boolean  "is_asset",                                                default: false
    t.datetime "deleted_at"
    t.decimal  "fix_amount",                     precision: 10, scale: 2
    t.string   "schedule",           limit: 255
    t.date     "payment_start_date"
    t.boolean  "autopay",                                                 default: false
    t.integer  "category_id",        limit: 4
    t.integer  "account_id",         limit: 4
  end

  add_index "debts", ["account_id"], name: "index_debts_on_account_id", using: :btree
  add_index "debts", ["category_id"], name: "index_debts_on_category_id", using: :btree
  add_index "debts", ["deleted_at"], name: "index_debts_on_deleted_at", using: :btree
  add_index "debts", ["name", "deleted_at"], name: "by_category_name", unique: true, using: :btree

  create_table "income_sources", force: :cascade do |t|
    t.string   "name",         limit: 255,                         null: false
    t.string   "pay_schedule", limit: 255,                         null: false
    t.string   "pay_day",      limit: 255,                         null: false
    t.decimal  "amount",                   precision: 8, scale: 2, null: false
    t.date     "start_date",                                       null: false
    t.date     "end_date",                                         null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "account_id",   limit: 4
  end

  add_index "income_sources", ["account_id"], name: "index_income_sources_on_account_id", using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  add_index "payment_methods", ["user_id", "name"], name: "by_user_name", unique: true, using: :btree
  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id", using: :btree

  create_table "spendings", force: :cascade do |t|
    t.string   "description",       limit: 255,                         null: false
    t.date     "spending_date",                                         null: false
    t.decimal  "amount",                        precision: 8, scale: 2, null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "budget_id",         limit: 4
    t.integer  "payment_method_id", limit: 4
    t.integer  "debt_balance_id",   limit: 4
  end

  add_index "spendings", ["budget_id"], name: "index_spendings_on_budget_id", using: :btree
  add_index "spendings", ["debt_balance_id"], name: "index_spendings_on_debt_balance_id", using: :btree
  add_index "spendings", ["payment_method_id"], name: "index_spendings_on_payment_method_id", using: :btree
  add_index "spendings", ["spending_date"], name: "index_spendings_on_spending_date", using: :btree

  create_table "user_contributors", id: false, force: :cascade do |t|
    t.integer "user_id",             limit: 4
    t.integer "contributor_user_id", limit: 4
  end

  add_index "user_contributors", ["contributor_user_id", "user_id"], name: "index_user_contributors_on_contributor_user_id_and_user_id", unique: true, using: :btree
  add_index "user_contributors", ["user_id", "contributor_user_id"], name: "index_user_contributors_on_user_id_and_contributor_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",        limit: 255
    t.string   "last_name",         limit: 255
    t.string   "email",             limit: 255
    t.string   "username",          limit: 255
    t.string   "password_digest",   limit: 255
    t.string   "remember_digest",   limit: 255
    t.string   "activation_digest", limit: 255
    t.boolean  "activated"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "account_balance_distributions", "account_balances"
  add_foreign_key "account_balance_distributions", "debts"
  add_foreign_key "account_balances", "accounts"
  add_foreign_key "account_balances", "debts"
  add_foreign_key "accounts", "users"
  add_foreign_key "budgets", "categories"
  add_foreign_key "categories", "users"
  add_foreign_key "debt_balances", "debts"
  add_foreign_key "debts", "accounts"
  add_foreign_key "debts", "categories"
  add_foreign_key "income_sources", "accounts"
  add_foreign_key "payment_methods", "users"
  add_foreign_key "spendings", "budgets"
  add_foreign_key "spendings", "debt_balances"
  add_foreign_key "spendings", "payment_methods"
end
