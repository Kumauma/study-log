class Todo < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :start_time, presence: true
end
