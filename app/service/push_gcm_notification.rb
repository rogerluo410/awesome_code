class PushGcmNotification
  include Serviceable

  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def call
    #TODO
  end

  private
end
