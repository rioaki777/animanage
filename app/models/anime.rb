class Anime < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, presence: true, length: { maximum: 500 }
end
