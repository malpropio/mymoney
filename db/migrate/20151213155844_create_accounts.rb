class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :name, limit: 20
      t.string :account_type, limit: 20

      t.timestamps null: false
    end

    add_index :accounts, [:name], name: 'index_accounts_on_name', unique: true, using: :btree
  end
end
