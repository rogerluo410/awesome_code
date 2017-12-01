module PushData
  class AppAccepted
    include Serviceable
    include Base

    attr_reader :app

    def initialize(app)
      @app = app
      @receiver = app.patient
    end

    def call
      PatientDashboardChannel.broadcast_app_accepted(app)
      push_data_via_fcm(op: 'app_accepted', app_id: app.id)
    end
  end
end
