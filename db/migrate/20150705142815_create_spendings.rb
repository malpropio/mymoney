class CreateSpendings < ActiveRecord::Migration
  def change
    create_table :spendings do |t|
      t.string :description, null: false
      t.references :category, index: true, foreign_key: true, null: false
      t.date :spending_date, null: false
      t.decimal :amount, null: false, precision: 8, scale: 2

      t.timestamps null: false
    end
    add_index :spendings, :spending_date
  end
end
