class AddPaymentMethodToSpendings < ActiveRecord::Migration
  def change
    add_reference :spendings, :payment_method, index: true, foreign_key: true
  end
end
