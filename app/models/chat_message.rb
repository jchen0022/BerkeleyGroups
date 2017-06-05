class ChatMessage < ApplicationRecord
  belongs_to :chatroom, optional: true
  belongs_to :user, optional: true

  validates :message, presence: true
end
