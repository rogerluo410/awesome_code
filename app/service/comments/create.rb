module Comments
  class Create
    include Serviceable

    validate :validate_params!

    def initialize(sender, params)
      @sender = sender
      @params = params
    end

    def call
      valid?
      set_appointment
      set_receiver
      create_comment
    end

    attr_reader :params, :sender, :appointment, :receiver

    def validate_params!
      if params[:appointment_id].blank?
        fail! "appointment_id must not be blank"
      end

      if params[:body].blank?
        fail! "body not be blank."
      end
    end

    def set_appointment
      @appointment = sender.appointments.ended.find_by_id(params[:appointment_id])
      fail! "#{sender.name} Can not have this appointment." unless @appointment
    end

    def set_receiver
      @receiver = appointment.patient if sender.type == 'Doctor'
      @receiver = appointment.doctor if sender.type == 'Patient'
    end

    def create_comment
      Comment.create!(
        appointment: appointment,
        receiver: receiver,
        sender: sender,
        body: params[:body]
      )
    end
  end
end
