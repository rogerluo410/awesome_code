module PushData
  class CallDeclined
    include Serviceable
    include Base

    attr_reader :app

    def initialize(app)
      @app = app
      @receiver = app.doctor
    end

    def call
      DeclineCallChannel.broadcast_call_declined(app)
      push_data_via_fcm(op: 'call_declined', app_id: app.id)
    end
  end
end
