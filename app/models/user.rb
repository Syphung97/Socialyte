class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  enum genders: [:male, :female]
  # mount_uploader :profile_img, ProfileUploader
  mount_uploader :profile_img, ProfileUploader
  validates :name, presence: true, length: {minimum:3, maximum:50}
  validates :email, presence: true, length: {minimum:3, maximum:100}, format: { with: VALID_EMAIL_REGEX },
  uniqueness: {case_sensitive: false}
  validates :gender, inclusion: {in: genders.keys}
  validate :profile_size
  validates :profile_img, presence: true
  has_secure_password

  before_save :downcase_email
  private

  def downcase_email
    self.email = email.downcase
  end

  def profile_size
    if profile_img.size > 5.megabytes
      errors.add(:profile_img, "should be less than 5MB")
    end
  end
end
