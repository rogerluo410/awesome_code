module PushData
  class CallStarted
    include Serviceable
    include Base

    attr_reader :app

    def initialize(app)
      @app = app
      @receiver = app.patient
    end

    def call
      CallChannel.broadcast_call_started(app)
      PushFcmMessageJob.perform_later(create_fcm_message)
    end

    private
    def create_fcm_message
    tokens = @receiver.devices.map(&:token)
    return if tokens.blank?

    FcmMessage.create!(
      receiver: receiver,
      tokens: tokens,
      notification: {
        title: "You receive an call",
        body: "#{@receiver.name} want video communicate to you",
      },
      data: {
        n_type: "call_start",
        op: 'call_started',
        app_id: app.id,
        doctor_id: app.doctor.id
      },
    )
  end
  end
end
