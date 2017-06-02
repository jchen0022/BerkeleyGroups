class Request < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group, optional: true

  validates :description, length: {minimum: 10, maximum: 140}

end
