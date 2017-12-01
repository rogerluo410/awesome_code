class AppointmentStatusJob < ApplicationJob
  queue_as :default

  def perform(appointment, user)
    if user.type == 'Doctor'
      # TODO
    elsif user.type == 'Patient'
      ActionCable.server.broadcast "patients/#{user.id}/appointment_channel", {
        data: Api::V1::AppointmentSerializer.new(appointment).as_json
      }
    end

  end

  private
end
