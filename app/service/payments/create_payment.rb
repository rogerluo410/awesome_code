module Payments
  class CreatePayment
    include Serviceable

    def initialize(patient, params)
      @patient = patient
      @appointment_id = params[:appointment_id]
      @checkout_id = params[:checkout_id]
    end

    def call
      set_appointment
      set_checkout
      validate_doctor_account

      transaction do
        set_event_to_processing
        charge_event_log = charge

        if charge_event_log.succeeded?
          set_event_to_succeeded
        else
          set_event_to_failed
          errors.add(:base, "Charge failed, please try with another card.")
        end
      end

      PushData::AppPaid.(appointment)

      appointment
    rescue ActiveModel::StrictValidationFailed
      errors.add :base, $!.message
    end

    protected

    attr_reader :patient, :appointment_id, :appointment, :checkout_id, :checkout

    def set_appointment
      fail! "appointment id can not be blank" if appointment_id.blank?

      @appointment = patient.appointments.find_by_id(appointment_id)

      fail! "appointment id is invalid" if appointment.blank?
      fail! "appointment already timeout" unless appointment.is_appointment_available?
      fail! "appointment already #{appointment.status}" unless appointment.pending?
      fail! "appointment already paid" if appointment.paid?
      fail! "consultation fee is paying, please wait for a while" if appointment.charge_event.processing?
    end

    def validate_doctor_account
      fail! "Doctor does not have a bank account" if appointment.doctor.bank_account.blank?
    end

    def set_checkout
      fail! "checkout id can not be blank" if checkout_id.blank?
      @checkout = patient.checkouts.find_by_id(checkout_id)
      fail! "checkout id is invalid" if checkout.blank?
    end

    def charge
      tracker = PaymentGateways::TrackChargeEvent.new(
        checkout: @checkout,
        amount: @appointment.consultation_fee * 100,
        appointment: @appointment,
      )

      charge = PaymentGateways::CreateCharge.new(tracker)
      charge_event_log = charge.call
    end

    def set_event_to_processing
      appointment.charge_event.update!(status: :processing)
    end

    def set_event_to_succeeded
      appointment.charge_event.update!(status: :succeeded)
    end

    def set_event_to_failed
      if appointment && appointment.charge_event.processing?
        appointment.charge_event.update!(status: :failed)
      end
    end
  end
end
