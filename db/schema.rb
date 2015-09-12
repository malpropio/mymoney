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

ActiveRecord::Schema.define(version: 20150912200636) do

  create_table "allocations", force: :cascade do |t|
    t.decimal  "savings",      precision: 8, scale: 2
    t.decimal  "rent",         precision: 8, scale: 2
    t.decimal  "student_loan", precision: 8, scale: 2
    t.decimal  "car_loan",     precision: 8, scale: 2
    t.decimal  "chase_buffer", precision: 8, scale: 2
    t.decimal  "boa_buffer",   precision: 8, scale: 2
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "allocations", ["end_date"], name: "index_allocations_on_end_date", using: :btree
  add_index "allocations", ["start_date"], name: "index_allocations_on_start_date", unique: true, using: :btree

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
  end

  create_table "debt_balances", force: :cascade do |t|
    t.integer  "debt_id",            limit: 4
    t.date     "due_date",                                              null: false
    t.decimal  "balance",                      precision: 10, scale: 2, null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.date     "payment_start_date"
  end

  add_index "debt_balances", ["debt_id", "due_date"], name: "by_debt_due_date", unique: true, using: :btree
  add_index "debt_balances", ["debt_id"], name: "index_debt_balances_on_debt_id", using: :btree
  add_index "debt_balances", ["payment_start_date"], name: "index_debt_balances_on_payment_start_date", using: :btree

  create_table "debts", force: :cascade do |t|
    t.string   "category",     limit: 255,             null: false
    t.string   "sub_category", limit: 255,             null: false
    t.string   "name",         limit: 255,             null: false
    t.integer  "due_day",      limit: 4,   default: 0, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "debts", ["category", "name"], name: "by_category_name", unique: true, using: :btree

  create_table "income_distributions", force: :cascade do |t|
    t.date     "distribution_date"
    t.decimal  "boa_chk",           precision: 8, scale: 2,                 null: false
    t.decimal  "chase_chk",         precision: 8, scale: 2,                 null: false
    t.boolean  "paid",                                      default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "income_distributions", ["distribution_date"], name: "index_income_distributions_on_distribution_date", unique: true, using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "payment_methods", ["name"], name: "index_payment_methods_on_name", unique: true, using: :btree

  create_table "spendings", force: :cascade do |t|
    t.string   "description",       limit: 255,                         null: false
    t.integer  "category_id",       limit: 4,                           null: false
    t.date     "spending_date",                                         null: false
    t.decimal  "amount",                        precision: 8, scale: 2, null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "budget_id",         limit: 4
    t.integer  "payment_method_id", limit: 4
  end

  add_index "spendings", ["budget_id"], name: "index_spendings_on_budget_id", using: :btree
  add_index "spendings", ["category_id"], name: "index_spendings_on_category_id", using: :btree
  add_index "spendings", ["payment_method_id"], name: "index_spendings_on_payment_method_id", using: :btree
  add_index "spendings", ["spending_date"], name: "index_spendings_on_spending_date", using: :btree

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

  add_foreign_key "budgets", "categories"
  add_foreign_key "debt_balances", "debts"
  add_foreign_key "spendings", "budgets"
  add_foreign_key "spendings", "categories"
  add_foreign_key "spendings", "payment_methods"
end
