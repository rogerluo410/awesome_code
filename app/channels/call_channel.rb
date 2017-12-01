class CallChannel < ApplicationCable::Channel
  class << self
    def channel_name(patient_id)
      "patients/#{patient_id}/call_channel"
    end

    def broadcast_call_started(app)
      broadcast(app.patient_id, data: {
        appointment_id: app.id,
        doctor: Api::V1::SessionUserSerializer.new(app.doctor).as_json,
      })
    end

    private

    def broadcast(patient_id, json)
      ActionCable.server.broadcast(channel_name(patient_id), json)
    end
  end

  def subscribed
    stop_all_streams
    if current_user_id.present?
      stream_from self.class.channel_name(current_user_id)
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
