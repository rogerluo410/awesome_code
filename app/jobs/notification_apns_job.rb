class NotificationApnsJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    logger.error "--------#{exception.message}"
  end

  def perform(notification)
    logger.info "--------sms notification.id: #{notification.id}"

    PushApnsNotification.call(notification)

    logger.info '--------finished'
  end
end
