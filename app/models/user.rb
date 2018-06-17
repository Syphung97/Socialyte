class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_reader :remember_token, :reset_token
  enum genders: [:male, :female]

  has_many :microposts, dependent: :destroy
  mount_uploader :profile_img, ProfileUploader
  validates :name, presence: true, length: {minimum:3, maximum:50}
  validates :email, presence: true, length: {minimum:3, maximum:100}, format: { with: VALID_EMAIL_REGEX },
  uniqueness: {case_sensitive: false}
  validates :gender, inclusion: {in: genders.keys}
  validate :profile_size
  validates :profile_img, presence: true
  has_secure_password

  before_save :downcase_email

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def create_reset_digest
    @reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def current_user? current_user
    self == current_user
  end

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
