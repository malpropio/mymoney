class AddDebtBalanceToSpendings < ActiveRecord::Migration
  def change
    add_reference :spendings, :debt_balance, index: true, foreign_key: true
  end
end
