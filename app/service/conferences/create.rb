module Conferences
  class Create
    include Serviceable

    validate :validate_appointment!

    def initialize(doctor, appointment_id)
      @appointment_id = appointment_id
      @doctor = doctor
    end

    def call
      valid?
      update_appointment
      @conference = appointment.conferences.create
    end

    attr_reader :appointment, :conference, :doctor

    private

    def validate_appointment!
      service = Conferences::Validation.call(doctor, @appointment_id)
      fail! service.error unless service.success?
      @appointment = service.appointment
    end

    def update_appointment
      service = UpdateAppointmentStatus.call(appointment, 'processing')
      fail!(service.error) unless service.success?
    end
  end
end

