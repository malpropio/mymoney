class AddAccountToIncomeSources < ActiveRecord::Migration
  def change
    add_reference :income_sources, :account, index: true, foreign_key: true
  end
end
