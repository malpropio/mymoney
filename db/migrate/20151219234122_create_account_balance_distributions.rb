class CreateAccountBalanceDistributions < ActiveRecord::Migration
  def change
    create_table :account_balance_distributions do |t|
      t.references :account_balance, index: true, foreign_key: true
      t.references :debt, index: true, foreign_key: true
      t.decimal :recommendation, null: false, :precision => 8, :scale => 2
      t.decimal :actual, null: false, :precision => 8, :scale => 2

      t.timestamps null: false
    end
  end
end
