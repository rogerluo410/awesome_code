class User < ApplicationRecord
  extend Enumerize
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # include Searchable
  mount_uploader :image, AvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :notifications
  has_one :address
  has_many :devices
  has_many :auth_tokens

  before_create :init_username

  validate :must_be_notified
  validate :must_be_valid_timezone
  validates_uniqueness_of :username, :allow_nil => false

  class << self
    # Only used in `init_username`
    def calc_uniq_username(basename)
      username = basename
      num = 0
      while User.exists?(username: username)
        num += 1
        username = "#{basename}#{num}"
      end
      username
    end
  end

  def name
    full_name.presence || username
  end

  def full_name
    pair = [first_name&.humanize, last_name&.humanize].delete_if(&:blank?)
    pair.blank? ? '' : pair.join(' ')
  end

  def short_name
    if first_name.present? && last_name.present?
      "#{first_name[0]}#{last_name[0]}".upcase
    else
      name.first(2).upcase
    end
  end

  def avatar_url
    url = image_url(:thumb)
    return default_avatar_url unless url
    url.starts_with?('http') ? url : "#{Rails.application.config.host_url}#{url}"
  end

  def default_avatar_url
    "#{Rails.application.config.host_url}/static/user_default_profile.jpg"
  end

  def decode_base64_image(origImage)
    image = DecodeBase64Image.convert_data_uri_to_upload(origImage)
  end

  def generate_video_token
    token = Twilio::Util::AccessToken.new ENV['TWILIO_ACCOUNT_SID'],
                                          ENV['TWILIO_API_KEY'], ENV['TWILIO_API_SECRET'], 3600, id

    grant = Twilio::Util::AccessToken::ConversationsGrant.new
    grant.configuration_profile_sid = ENV['TWILIO_CONFIGURATION_SID']
    token.add_grant grant
    token
  end

  def current_time
    Time.current.in_time_zone(local_timezone)
  end

  def build_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

    self.reset_password_token = enc
    self.reset_password_sent_at = Time.current
    save(validate: false)
    raw
  end

  def generate_auth_token
    self.auth_tokens.create.id
  end

  def device_tokens
    devices.map(&:token)
  end

  private

  def init_username
    return if username.present?
    self.username = self.class.calc_uniq_username(email.split(/@/).first)
  end

  def must_be_notified
    unless (notify_sms? or notify_email? or notify_system?)
      errors.add(:base, 'You must keep one way to receive the notifications')
    end
  end

  def must_be_valid_timezone
    errors.add(:base, 'Timezone is invalid') unless UtilsTimeZone.valid_timezone?(local_timezone)
  end
end
