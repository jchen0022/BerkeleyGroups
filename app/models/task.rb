class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group, optional: true
  
  validates :name, presence: true
  validates :priority, numericality: {only_integer: true, greater_than: 0, less_than: 100}

  def self.options_for_priority
    (1..10).map do |n|
      [n, n]
    end
  end

end
