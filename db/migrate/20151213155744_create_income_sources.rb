class CreateIncomeSources < ActiveRecord::Migration
  def change
    create_table :income_sources do |t|
      t.string :name, null: false
      t.string :pay_schedule, null:false
      t.string :pay_day, null: false
      t.decimal :amount, null: false, :precision => 8, :scale => 2
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps null: false
    end
  end
end
