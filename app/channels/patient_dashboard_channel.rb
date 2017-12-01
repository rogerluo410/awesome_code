class PatientDashboardChannel < ApplicationCable::Channel
  class << self
    def dashboard_channel(patient_id)
      "p/#{patient_id}/dashboard"
    end

    def broadcast_app_accepted(app)
      broadcast(app.patient_id, op: 'app_accepted', app_id: app.id.to_s)
    end

    def broadcast_app_declined(app)
      broadcast(app.patient_id, op: 'app_declined', app_id: app.id.to_s)
    end

    private

    def broadcast(patient_id, json)
      ActionCable.server.broadcast(dashboard_channel(patient_id), json)
    end
  end

  def subscribed
    stop_all_streams
    stream_from self.class.dashboard_channel(current_user_id)
  end

  def unsubscribed
    stop_all_streams
  end
end
