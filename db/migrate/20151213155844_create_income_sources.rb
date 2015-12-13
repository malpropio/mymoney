class CreateIncomeSources < ActiveRecord::Migration
  def change
    create_table :income_sources do |t|
      t.string :name
      t.string :pay_schedule
      t.string :pay_day
      t.decimal :amount, null: false, :precision => 8, :scale => 2
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
