class CreateAccountBalances < ActiveRecord::Migration
  def change
    create_table :account_balances do |t|
      t.date :balance_date, null: false
      t.references :account, index: true, foreign_key: true
      t.decimal :amount, null: false, precision: 8, scale: 2
      t.decimal :buffer, null: false, precision: 8, scale: 2
      t.references :debt, index: true, foreign_key: true
      t.boolean :paid

      t.timestamps null: false
    end
  end
end
