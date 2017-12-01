module Prescriptions
  class Update
    include Serviceable

    validate :validate_params!

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      valid?
      set_appointment
      set_prescriptions
      set_pharmacy
      send_email
      update_prescriptions
    end

    attr_reader :params, :user, :appointment

    def validate_params!
      if params[:pharmacy_id].blank?
        fail! "pharmacy_id not be blank."
      end
    end

    def set_prescriptions
      @prescriptions = @appointment.prescriptions
      fail! "The appointment have no prescriptions." unless @prescriptions.size > 0

      unless @prescriptions.last.status_pending?
        fail! "The prescriptions has send to pharmacy"
      end
    end

    def set_appointment
      @appointment = user.appointments.ended.find_by_id(params[:appointment_id])
      fail! "#{user.name} doesn't have this appointment." unless @appointment
    end

    def set_pharmacy
      @pharmacy = Pharmacy.find_by_id(params[:pharmacy_id])
      fail! "Invalid pharmacy id" unless @pharmacy
    end

    def send_email
      # PrescriptionMailer.send_to_pharmacy_email(@prescriptions.pluck(:id), @pharmacy, @appointment).deliver_later
    end

    def update_prescriptions
      transaction do
        @prescriptions.each do |prescription|
          prescription.update!(pharmacy_id: @pharmacy.id, status: Prescription.status.delivered)
        end
      end
      @prescriptions
    end

  end
end
