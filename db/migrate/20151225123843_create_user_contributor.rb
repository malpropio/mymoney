class CreateUserContributor < ActiveRecord::Migration
  def change
    create_table :user_contributors, id: false do |t|
      t.integer :user_id
      t.integer :contributor_user_id
    end

    add_index(:user_contributors, [:user_id, :contributor_user_id], unique: true)
    add_index(:user_contributors, [:contributor_user_id, :user_id], unique: true)
  end
end
