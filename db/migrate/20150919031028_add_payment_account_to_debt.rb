class AddPaymentAccountToDebt < ActiveRecord::Migration
  def change
    add_column :debts, :pay_from, :string, default: 'Bank Of America'
  end
end
