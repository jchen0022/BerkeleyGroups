class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tasks, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  before_save :format_name
  before_update :format_name

  def self.max_groups
    return 8
  end

  private 

  def format_name
    self.first_name = self.first_name.upcase_first
    self.last_name = self.last_name.upcase_first
  end

end
