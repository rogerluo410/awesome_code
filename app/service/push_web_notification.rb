class PushWebNotification
  include Serviceable

  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def call
    ActionCable.server.broadcast(
      "users/#{notification.user_id}/notification_channel",
      data: Api::V1::NotificationSerializer.new(notification).as_json,
    )
  end
end
