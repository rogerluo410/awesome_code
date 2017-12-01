class PushSmsNotification
  include Serviceable

  attr_reader :notification


  def initialize(notification)
    @notification = notification
    @user = @notification.user
  end

  def call
    client.account.messages.create(
      to: @user.phone,
      from: ENV['TWILIO_NUMBER'],
      body: @notification.body,
    )
  rescue Twilio::REST::RequestError => e
    Rails.logger.error "Sending SMS error: #{e}"
  end

  private

  def client
    @client ||= Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID_PHONE'], ENV['TWILIO_AUTH_TOKEN'])
  end
end
