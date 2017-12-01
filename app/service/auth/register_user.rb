module Auth
  class RegisterUser
    include Serviceable

    attr_reader :patient

    validates! :email, presence: true
    validate :validate_email!

    def initialize(params)
      @email = params[:email]
    end

    def call
      valid?
      build_patient
      send_reset_password_email
    end

    private

    attr_reader :email

    def validate_email!
      unless Patient.find_by_email(@email).blank?
        strict_validation_failed! 'This email has already registered, please login directly.'
      end
    end

    def build_patient
      predefined_props = {
        email: @email,
        password: SecureRandom.hex(4)
      }
      @patient = Patient.new(predefined_props)
      @patient.skip_confirmation!
      @patient.save!
    end

    def send_reset_password_email
      token = @patient.build_reset_password_token
      # RegisterMailer.register_notification(@patient, token).deliver_later
    end
  end
end
