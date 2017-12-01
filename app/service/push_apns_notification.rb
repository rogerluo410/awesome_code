class PushApnsNotification
  include Serviceable

  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def call
  end

  private
end
