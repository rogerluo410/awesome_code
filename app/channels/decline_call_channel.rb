class DeclineCallChannel < ApplicationCable::Channel
  class << self
    def channel_name(doctor_id)
      "doctors/#{doctor_id}/decline_call_channel"
    end

    def broadcast_call_declined(app)
      broadcast(app.doctor_id, data: {
        appointment_id: app.id,
        patient_id: app.patient_id,
      })
    end

    private

    def broadcast(doctor_id, json)
      ActionCable.server.broadcast(channel_name(doctor_id), json)
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
