module FcmFactory
  def self.create
    api_key = Rails.application.secrets.fcm_api_key
    if api_key.blank?
      raise FcmConfigError, "Can't find 'fcm_api_key' in secrets.yml"
    end
    FCM.new(api_key)
  end
end
