module PushData
  class AppPaid
    include Serviceable
    include Base

    attr_reader :app

    def initialize(app)
      @app = app
      @receiver = app.doctor
    end

    def call
      DoctorWorkspaceChannel.broadcast_app_paid(app)
      push_data_via_fcm(op: 'app_paid', app_id: app.id)
    end
  end
end
