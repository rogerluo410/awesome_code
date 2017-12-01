class PatientAppointmentChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    if self.current_user_id.present?
      stream_from "patients/#{self.current_user_id}/appointment_channel"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
