class CreateIncomeDistributions < ActiveRecord::Migration
  def change
    create_table :income_distributions do |t|
      t.date :distribution_date
      t.decimal :boa_chk, null: false, :precision => 8, :scale => 2
      t.decimal :chase_chk, null: false, :precision => 8, :scale => 2
      t.boolean :paid, default: false

      t.timestamps null: false
    end
    add_index :income_distributions, :distribution_date, unique: true
  end
end
