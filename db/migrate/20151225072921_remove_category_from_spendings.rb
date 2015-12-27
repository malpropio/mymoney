class RemoveCategoryFromSpendings < ActiveRecord::Migration
  def change
    remove_foreign_key :spendings, :category
    remove_index :spendings, :category_id
    remove_column :spendings, :category_id
  end
end
