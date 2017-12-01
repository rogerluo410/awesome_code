module Api
  module V1
    class AppointmentProductSerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :start_time,
        :end_time,
      )

      has_many :scheduled_appointments, serializer: DocAppointmentSerializer

      def scheduled_appointments
        object.appointments.scheduled.order(:id)
      end
    end
  end
end
