class NotificationWebJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    logger.error "--------#{exception.message}"
  end

  def perform(notification)

    logger.info "--------system notification.id: #{notification.id}"

    PushWebNotification.call(notification)

    logger.info '--------finished'
  end
end
