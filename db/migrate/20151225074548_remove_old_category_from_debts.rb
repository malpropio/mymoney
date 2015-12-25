class RemoveOldCategoryFromDebts < ActiveRecord::Migration
  def change
    remove_column :debts, :old_category
  end
end
