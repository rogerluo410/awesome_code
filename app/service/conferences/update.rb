module Conferences
  class Update
    include Serviceable

    validates! :id, presence: true
    validate :validate_update_type!
    validate :validate_time_params!
    validate :validate_status_params!
    validate :validate_conference!

    def initialize(conferenceId, params)
      @id = conferenceId
      @update_type = params[:update_type]
      @status = params[:status]
      @twilio_id = params[:twilio_id]
      @time_type = params[:time_type]
    end

    def call
      valid?

      if update_status?
        update_conference_status
      else
        update_conference_time
      end

      @conference
    end

    private

    attr_reader :id

    def update_time?
      @update_type == 'time'
    end

    def update_status?
      @update_type == 'status'
    end

    def update_start_time?
      @time_type == 'start_time'
    end

    def update_end_time?
      @time_type == 'end_time'
    end

    def validate_update_type!
      fail! 'Update type can not be blank.' if @update_type.blank?
      fail! 'Update type is invalid, can only be time or status.' unless update_time? || update_status?
    end

    def validate_time_params!
      return unless update_time?
      fail! 'Time type can not be blank.' if @time_type.blank?
      fail! 'Time type is invalid, can only be start_time or end_time' unless update_start_time? || update_end_time?
      fail! 'Twilio id can not be blank' if @twilio_id.blank?
    end

    def validate_status_params!
      return unless update_status?
      fail! 'Status can not be blank.' if @status.blank?
    end

    def validate_conference!
      @conference = Conference.find_by_id(@id)
      fail! "Can not find conference with id #{@id}" unless @conference.present?
      @appointment = @conference.appointment
      fail! "Can not find the appointment for conference with id #{@id}" unless @appointment.present?
    end

    def update_conference_status
      @conference.update!(status: @status)
    end

    def update_conference_time
      if update_start_time?
        @conference.update!(start_time: Time.now, twillo_id: @twilio_id)
      else
        @conference.update!(end_time: Time.now, twillo_id: @twilio_id, status: 'success')

        appointmentService = UpdateAppointmentStatus.call(@appointment, 'finished')
        fail! appointmentService.error unless appointmentService.success?
      end
    end
  end
end
