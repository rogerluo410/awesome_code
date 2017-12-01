class AuthToken < ApplicationRecord
  belongs_to :user

  before_create :set_expired_time

  DEFAULT_EXPIRED_THRESHOID = 30  # days
  DEFAULT_EXPAND_THRESHOID = 7 # days

  private
  def set_expired_time
    self.expired_at =Time.zone.now + DEFAULT_EXPIRED_THRESHOID.day
  end
end
