class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :tasks, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :chatrooms, dependent: :destroy

  validates :name, length: {minimum: 5}
  validates :course, length: {minimum: 2, maximum: 20}
  validates :size, presence: true, numericality: {greater_than: 1, less_than: 5, only_integer: true}

  filterrific(
    default_filter_params: {group_size: 4},
    available_filters: [
      :name_query,
      :course_query,
      :group_size,
    ]
  )

  scope :name_query, lambda { |query|
    return nil if query.blank?

    query = query.to_s.downcase
    query = ('%' + query.gsub('*', '%') + '%').gsub(/%+/, '%')
    where( "(LOWER(groups.name) LIKE ?)", query)
  }

  scope :course_query, lambda { |query|
    return nil if query.blank?

    query = query.to_s.downcase
    query = ('%' + query.gsub('*', '%') + '%').gsub(/%+/, '%')
    where( "(LOWER(groups.course) LIKE ?)", query)
  }

  scope :group_size, lambda { |query|
    where(size: query)
  }

  def self.options_for_size
    (2..4).map do |n|
      [n, n]
    end
  end
  
  def options_for_user 
    users.all.map do |user|
      [user.first_name + " " + user.last_name, user.id]
    end
  end
end
