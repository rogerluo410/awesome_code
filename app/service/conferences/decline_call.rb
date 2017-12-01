module Conferences
  class DeclineCall
    include Serviceable

    validate :validate_patient!
    validate :validate_appointment!

    def initialize(patient, appointment_id)
      @patient = patient
      @appointment_id = appointment_id
    end

    def call
      valid?
      PushData::CallDeclined.(appointment)
    end

    private

    attr_reader :appointment

    def validate_patient!
      fail! 'Patient can not be blank.' if @patient.blank?
    end

    def validate_appointment!
      service = Conferences::Validation.call(@patient, @appointment_id)
      fail! service.error unless service.success?
      @appointment = service.appointment
    end
  end
end
