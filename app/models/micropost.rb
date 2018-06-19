class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  scope :desc, ->{order created_at: :desc}
  scope :following_feed, (lambda do |following_ids, id|
    where "user_id IN (?) OR user_id = ?", following_ids, id
  end)
end
