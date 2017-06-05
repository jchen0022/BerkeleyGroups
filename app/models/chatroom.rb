class Chatroom < ApplicationRecord
  has_many :chat_messages, dependent: :destroy
  belongs_to :group, optional: true
end
