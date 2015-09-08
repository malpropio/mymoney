class CreateIncomeDistributions < ActiveRecord::Migration
  def change
    create_table :income_distributions do |t|
      t.date :distribution_date
      t.decimal :amex, null: false, :precision => 8, :scale => 2
      t.decimal :freedom, null: false, :precision => 8, :scale => 2
      t.decimal :travel, null: false, :precision => 8, :scale => 2
      t.decimal :cash, null: false, :precision => 8, :scale => 2
      t.decimal :jcp, null: false, :precision => 8, :scale => 2
      t.decimal :express, null: false, :precision => 8, :scale => 2
      t.decimal :boa_chk, null: false, :precision => 8, :scale => 2
      t.decimal :chase_chk, null: false, :precision => 8, :scale => 2

      t.timestamps null: false
    end
    add_index :income_distributions, :distribution_date, unique: true
  end
end
