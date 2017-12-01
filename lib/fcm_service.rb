# A simple wrapper for FCM
#
# The main goals are to encapsulate details about initialising FCM instance, and wrap response into
# an object.
class FcmService
  attr_reader :fcm

  def initialize
    @fcm = init_fcm
  end

  def send(tokens, opts)
    raw_resp = fcm.send(tokens, opts)
    FcmResponse.new(raw_resp.merge(body: JSON.parse(raw_resp[:body])))
  rescue Net::OpenTimeout => err
    raise FcmSendError, "#{err.class.name}: #{err.message}"
  end

  private

  def init_fcm
    raise FcmConfigError, "ENV['FCM_API_KEY'] not provided" if api_key.blank?
    FCM.new(api_key)
  end

  def api_key
    ENV['FCM_API_KEY']
  end
end
