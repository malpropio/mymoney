class RevampDebt < ActiveRecord::Migration
  def change
    remove_column :debts, :due_day, :integer
    add_column :debts, :is_asset, :boolean, default: false

    add_column :debt_balances, :target_balance, :decimal, null: false, precision: 10, scale: 2, default: 0.0
  end
end
