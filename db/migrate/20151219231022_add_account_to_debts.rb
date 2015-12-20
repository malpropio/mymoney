class AddAccountToDebts < ActiveRecord::Migration
  def change
    add_reference :debts, :account, index: true, foreign_key: true, null: false
  end
end
