class CreateSpendings < ActiveRecord::Migration
  def change
    create_table :spendings do |t|
      t.string :description
      t.references :category, index: true, foreign_key: true
      t.datetime :spending_date_ts
      t.decimal :amount, precision: 4, scale: 2

      t.timestamps null: false
    end
    add_index :spendings, :spending_date_ts
  end
end
