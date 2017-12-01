module Conferences
  class Notify
    include Serviceable

    validates! :doctor, presence: true
    validate :validate_appointment!

    def initialize(doctor, params)
      @doctor = doctor
      @appointment_id = params[:appointment_id]
    end

    def call
      valid?
      PushData::CallStarted.(appointment)
    end

    private

    attr_reader :doctor, :appointment

    def validate_appointment!
      service = Conferences::Validation.call(doctor, @appointment_id)
      fail! service.error unless service.success?
      @appointment = service.appointment
    end
  end
end
