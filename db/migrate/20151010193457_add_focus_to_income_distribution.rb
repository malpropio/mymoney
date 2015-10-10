class AddFocusToIncomeDistribution < ActiveRecord::Migration
  def change
    add_column :income_distributions, :chase_focus, :string
    add_column :income_distributions, :boa_focus, :string
  end
end
