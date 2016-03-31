class AlterChatMessagesAddApiUserId < ActiveRecord::Migration
  def change
    add_column :chat_messages, :api_user_id, :integer
    add_index :chat_messages, :api_user_id
  end
end
