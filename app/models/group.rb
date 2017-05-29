class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :tasks, dependent: :destroy

  filterrific(
    default_filter_params: {course_query: "61", name_query: "myG"},
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
    [[1, 1], [2, 2], [3, 3], [4, 4]]
  end

end
