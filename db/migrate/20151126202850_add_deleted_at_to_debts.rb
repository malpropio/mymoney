class AddDeletedAtToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :deleted_at, :datetime
    add_index :debts, :deleted_at
  end
end
