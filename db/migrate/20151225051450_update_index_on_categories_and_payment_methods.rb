class UpdateIndexOnCategoriesAndPaymentMethods < ActiveRecord::Migration
  def change
    remove_index :payment_methods, :name

    add_index :categories, [:user_id, :name], unique: true, name: 'by_user_name'
    add_index :payment_methods, [:user_id, :name], unique: true, name: 'by_user_name'
  end
end
