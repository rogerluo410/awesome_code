module PushData
  class AppCreated
    include Serviceable
    include Base

    attr_reader :app

    def initialize(app)
      @app = app
      @receiver = app.doctor
    end

    def call
      DoctorWorkspaceChannel.broadcast_app_created(receiver.id)
      push_data_via_fcm(op: 'app_created', app_id: app.id)
    end
  end
end
