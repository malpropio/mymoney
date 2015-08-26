class AddBudgetToSpendings < ActiveRecord::Migration
  def change
    add_reference :spendings, :budget, index: true, foreign_key: true
  end
end
