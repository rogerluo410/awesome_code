class Device < ApplicationRecord
  belongs_to :user

  enum platform: [:ios, :android]

  scope :platform_and_token, -> (platform, token) { where(platform: Device.platforms[platform], token: token) }

  class << self
    def get_by_platform_and_token(platform, token)
      platform_and_token(platform, token).last
    end
  end

  def self.replace_token(platform:, old_token:, new_token:)
    old_device = find_by_platform_and_token(platform, old_token)
    return unless old_device

    new_device = find_by_platform_and_token(platform, new_token)
    if new_device
      old_device.delete
    else
      old_device.update(token: new_token)
    end
  end
end
