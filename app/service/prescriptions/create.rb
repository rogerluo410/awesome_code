module Prescriptions
  class Create
    include Serviceable

    validate :validate_params!

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      valid?
      set_appointment
      begin
        create_prescription
      rescue Excon::Error => ex
        Rails.logger.error ex.response
        fail! 'Failed to upload file'
      end
    end

    attr_reader :params, :user, :appointment

    def validate_params!
      if params[:file].blank?
        fail! "file not be blank."
      end
    end

    def set_appointment
      @appointment = user.appointments.ended.find_by_id(params[:appointment_id])
      fail! "#{user.name} Can not have this appointment." unless @appointment
    end


    def create_prescription
      Prescription.create(
        appointment_id: params[:appointment_id],
        file: params[:file]
        )
    end
  end
end
