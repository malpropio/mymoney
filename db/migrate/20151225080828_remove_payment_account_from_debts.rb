class RemovePaymentAccountFromDebts < ActiveRecord::Migration
  def change
    remove_column :debts, :pay_from
  end
end
