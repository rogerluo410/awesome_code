module AppointmentTransfers
  class CreateTransferCore
    include Serviceable

    def initialize(appointment)
      @appointment = appointment
    end

    def call
      validate_appointment!
      set_destination

      transaction do
        set_event_to_processing
        transfer_service = transfer

        if transfer_service.succeeded?
          set_event_to_succeeded
        else
          set_event_to_failed
          errors.add(:base, 'Transfer failed, please try it later.')
        end
        transfer_service
      end
    rescue ActiveModel::StrictValidationFailed
      set_event_to_failed
      errors.add :base, $!.message
    end

    protected

    attr_reader :patient, :appointment_id, :appointment, :destination

    def validate_appointment!
      fail!("appointment is blank") if appointment.blank?
      fail!("appointment not paid") unless appointment.paid?
      fail!("appointment not finished") unless appointment.finished?
      fail!("consultation fee already transferred to doctor") if appointment.transferred?
      fail!("consultation fee is transferring, please wait for a while") if appointment.transfer_event.processing?
    end

    def set_destination
      bank_account = appointment.doctor.bank_account
      fail!("doctor does not have a bank account") if bank_account.blank?
      @destination = bank_account.account_id
    end

    def transfer
      tracker = TransferGateways::TrackTransferEvent.new(
          destination: destination,
          amount: appointment.doctor_fee * 100,
          appointment: appointment,
        )

      transfer = TransferGateways::Transfer.new(tracker)
      transfer_service = transfer.call
    end

    def set_event_to_processing
      appointment.transfer_event.update!(status: :processing)
    end

    def set_event_to_succeeded
      appointment.transfer_event.update!(status: :succeeded)
    end

    def set_event_to_failed
      if appointment && appointment.transfer_event.processing?
        appointment.transfer_event.update!(status: :failed)
      end
    end
  end
end
