class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_messages do |t|
      t.text :message
      t.belongs_to :chatroom, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
