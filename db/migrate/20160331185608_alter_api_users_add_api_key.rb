class AlterApiUsersAddApiKey < ActiveRecord::Migration
  def change
    add_column :api_users, :api_key, :string
    add_column :api_users, :test_api_key, :string
    add_index :api_users, :api_key
    add_index :api_users, :test_api_key
  end
end
