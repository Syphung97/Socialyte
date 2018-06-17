class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  scope :desc, ->{order created_at: :desc}
end
