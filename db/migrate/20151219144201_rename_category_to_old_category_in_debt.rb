class RenameCategoryToOldCategoryInDebt < ActiveRecord::Migration
  def change
    rename_column :debts, :category, :old_category
  end
end
