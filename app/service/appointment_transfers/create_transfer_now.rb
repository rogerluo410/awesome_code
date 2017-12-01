module AppointmentTransfers
  class CreateTransferNow
    include Serviceable

    def initialize(patient, params)
      @appointment_id = params[:appointment_id]
      @patient = patient
    end

    def call
      set_appointment
      appointment.delete_default_transfer
      transfer
      appointment
    rescue ActiveModel::StrictValidationFailed
      errors.add :base, $!.message
    end

    protected

    attr_reader :patient, :doctor, :appointment_id, :appointment

    def set_appointment
      fail!("appointment_id can not be blank") if appointment_id.blank?
      @appointment = patient.appointments.find_by_id(@appointment_id)
      fail!("appointment id is invalid") if @appointment.blank?
    end

    def transfer
      service = ::AppointmentTransfers::CreateTransferCore.call(appointment)
      if service.success?
        service.result
      else
        fail!(service.error)
      end
    end
  end
end
