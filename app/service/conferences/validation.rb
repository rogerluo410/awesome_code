module Conferences
  class Validation
    include Serviceable

    validate :validate_user!
    validate :validate_appointment!

    def initialize(user, appointment_id)
      @appointment_id = appointment_id
      @user = user
    end

    def call
      valid?
      true
    end

    attr_reader :appointment
    private
    def is_patient?
      @user.class.name == 'Patient'
    end

    def is_doctor?
      @user.class.name == 'Doctor'
    end

    def belongs_to_patient?
      @appointment.patient_id == @user.id && is_patient?
    end

    def belongs_to_doctor?
      @appointment.doctor_id == @user.id && is_doctor?
    end

    def validate_user!
      fail! 'User can not be blank.' if @user.nil?
      fail! 'Only patient or doctor can join video call.' unless is_doctor? || is_patient?
    end

    def validate_appointment!
      fail! 'Appointment id can not be blank.' if @appointment_id.blank?
      @appointment = Appointment.find_by_id @appointment_id
      fail! 'Can not find the appointment.' if @appointment.nil?

      fail! 'This appointment does not belong to you.' unless belongs_to_doctor? || belongs_to_patient?
      message = @appointment.is_turn_to_consult?
      fail! message unless message.blank?
    end

  end
end
