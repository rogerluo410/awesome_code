class NotificationGcmJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    logger.error "--------#{exception.message}"
  end

  def perform(notification)
    logger.info "--------gcm notification.id: #{notification.id}"

    PushGcmNotification.call(notification)

    logger.info '--------finished'
  end
end
