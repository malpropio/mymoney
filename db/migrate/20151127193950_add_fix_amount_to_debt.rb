class AddFixAmountToDebt < ActiveRecord::Migration
  def change
    add_column :debts, :fix_amount, :decimal, precision: 10, scale: 2, default: nil
    add_column :debts, :schedule, :string
    add_column :debts, :payment_start_date, :date, default: nil
    add_column :debts, :autopay, :boolean, default: false
  end
end
