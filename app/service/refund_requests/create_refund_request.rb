module RefundRequests
  class CreateRefundRequest
    include Serviceable

    def initialize(patient, params)
      @patient = patient
      @appointment_id = params[:appointment_id]
    end

    def call
      set_appointment
      appointment.delete_default_transfer
      create_request
    rescue ActiveModel::StrictValidationFailed
      errors.add :base, $!.message
    end

    protected

    attr_reader :patient, :appointment_id, :appointment

    def set_appointment
      fail!("appointment_id can not be blank.") if appointment_id.blank?
      @appointment = patient.appointments.find_by_id(@appointment_id)
      fail!("appointment_id is invalid.") if @appointment.blank?
      fail!("Appointment not finished.") unless @appointment.finished?
      fail!("Appointment not paid.") unless @appointment.paid?
      fail!("Appointment has already requested for refund.") if @appointment.refund_request.present?
    end

    def create_request
      success_charge_log = @appointment.charge_event_logs.with_status(:succeeded).first
      success_transfer_log = @appointment.transfer_event_logs.with_status(:paid).first
      appointment.create_refund_request!(charge_event_log: success_charge_log, transfer_event_log: success_transfer_log)
    end
  end
end
