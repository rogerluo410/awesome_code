module PushData
  module Base
    extend ActiveSupport::Concern

    included do
      attr_reader :receiver
    end

    def push_data_via_fcm(data)
      tokens = receiver.device_tokens
      return if tokens.blank?
      fcm_message = FcmMessage.create!(receiver: receiver, tokens: tokens, data: data)
      PushFcmMessageJob.perform_later(fcm_message)
    end
  end
end
