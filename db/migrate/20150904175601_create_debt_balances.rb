class CreateDebtBalances < ActiveRecord::Migration
  def change
    create_table :debt_balances do |t|
      t.references :debt, index: true, foreign_key: true
      t.date :due_date, null: false
      t.decimal :balance, null: false, precision: 10, scale: 2

      t.timestamps null: false
    end

    add_index :debt_balances, [:debt_id, :due_date], unique: true, name: 'by_debt_due_date'
  end
end
