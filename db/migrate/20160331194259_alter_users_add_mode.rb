class AlterUsersAddMode < ActiveRecord::Migration
  def change
    add_column :users, :mode, :string
    add_column :users, :api_user_id, :string
    add_index :users, :api_user_id
  end
end
