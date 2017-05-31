class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group, optional: true

  def self.options_for_priority
    (1..10).map do |n|
      [n, n]
    end
  end

end
