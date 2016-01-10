class CreateDebts < ActiveRecord::Migration
  def up
    unless ActiveRecord::Base.connection.table_exists? 'debts'
      create_table :debts do |t|
        t.string :category, null: false
        t.string :sub_category, null: false
        t.string :name, null: false
        t.integer :due_day, null: false, default: 0

        t.timestamps null: false
      end
    end
  end

  def down
    remove_index :debts, name: 'by_category_name'
  end
end
