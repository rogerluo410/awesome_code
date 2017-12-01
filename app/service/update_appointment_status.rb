class UpdateAppointmentStatus
  include Serviceable

  validate :validate_status!

  def initialize(appointment, status)
    @appointment = appointment
    @status = status
  end

  def call
    valid?
    return if (@appointment.try(:status).to_s == @status.to_s)
    send("#{@status}_processor")
    @status
  rescue AASM::InvalidTransition
    fail! $!.message
  end

  private

  def validate_status!
    unless Appointment::STATUS_HASH.keys.include?(@status.to_sym)
      fail! 'Unknown status'
    end
    if !@appointment.paid? && @status.to_sym == :accepted
      fail! 'The appointment has not been paid.'
    end
  end

  def accepted_processor
    @appointment.event_accepted!
    PushData::AppAccepted.(@appointment)
  end

  def decline_processor
    @appointment.event_decline!
    PushData::AppDeclined.(@appointment)
  end

  def processing_processor
    @appointment.event_processing!
  end

  def finished_processor
    @appointment.event_finished!
  end
end
