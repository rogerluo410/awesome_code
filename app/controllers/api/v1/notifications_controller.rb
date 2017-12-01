class Api::V1::NotificationsController < Api::V1::ApiBaseController
  before_action :authenticate!

  def index
    @notifications = current_user.notifications

    @badge = @notifications.unread.count

    @notifications = @notifications.cursor_at(params[:next_cursor]) if params[:next_cursor].present?
    @notifications = @notifications.order(id: :desc)

    @next_cursor = @notifications.offset(10).first.try(:id)
    @notifications = @notifications.limit(10)

    meta = {
      badge: @badge,
      next_cursor: @next_cursor
    }

    render json: @notifications, each_serializer: serializer, root: 'data', meta: meta
  end

  def mark_read
    @notification = current_user.notifications.find(params[:id])

    if @notification.update(is_read: true)
      render status: 200, json: {data: {badge: current_user.notifications.unread.count, notification: serializer.new(@notification).as_json }}
    else
      render_api_error status: 422, message: @notification.errors.full_messages[0]
    end
  end

  private
  def serializer
    Api::V1::NotificationSerializer
  end
end
