class UpdateIndexOnAccounts < ActiveRecord::Migration
  def change
    remove_index :accounts, :name
    add_index :accounts, [:user_id, :name], unique: true, name: 'by_user_name'
  end
end
