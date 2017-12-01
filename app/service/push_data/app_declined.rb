module PushData
  class AppDeclined
    include Serviceable
    include Base

    attr_reader :app

    def initialize(app)
      @app = app
      @receiver = app.patient
    end

    def call
      PatientDashboardChannel.broadcast_app_declined(app)
      push_data_via_fcm(op: 'app_declined', app_id: app.id)
    end
  end
end
