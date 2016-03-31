class AlterChatMessagesAddMode < ActiveRecord::Migration
  def change
    add_column :chat_messages, :mode, :string
    add_index :chat_messages, :mode
  end
end
