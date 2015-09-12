class AddPaymentStartDateToDebtBalance < ActiveRecord::Migration
  def change
    add_column :debt_balances, :payment_start_date, :date
    add_index :debt_balances, :payment_start_date
  end
end
