class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    if self.current_user_id.present?
      stream_from "users/#{self.current_user_id}/notification_channel"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
