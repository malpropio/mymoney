class ModifyDebtIndex < ActiveRecord::Migration
  def up
    add_index :debts, [:category, :name, :deleted_at], unique: true, name: 'by_category_name'
  end

  def down
    remove_index :debts, name: 'by_category_name'
  end
end
