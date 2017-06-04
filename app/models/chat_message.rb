class ChatMessage < ApplicationRecord
  belongs_to :chat_room, optional: true
  belongs_to :user, optional: true
end
