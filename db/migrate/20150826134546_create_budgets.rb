class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.references :category, index: true, foreign_key: true
      t.date :budget_month, null: false
      t.decimal :amount, null: false, precision: 8, scale: 2

      t.timestamps null: false
    end

    add_index :budgets, [:category_id, :budget_month], unique: true, name: 'by_category_month'
  end
end
