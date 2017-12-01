module Auth
  class Signup
    include Serviceable

    validate :validate_role!
    validate :validate_email!
    validate :validate_password!

    def initialize(params)
      @role = params[:role]
      @email = params[:email]
      @password = params[:password]
      @phone_number = params[:phone_number]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
    end

    def call
      valid?
      build_user
    rescue ActiveRecord::RecordInvalid
      fail! $!.message
    end

    attr_reader :message

    private
    def is_patient?
      @role.downcase == 'Patient'.downcase
    end

    def is_doctor?
      @role.downcase == 'Doctor'.downcase
    end

    def validate_role!
      fail! 'User role can not be blank.' if @role.blank?
      fail! 'User role can only be patient or doctor.' unless is_patient? || is_doctor?
    end

    def validate_email!
      fail! 'Email can not be blank.' if @email.blank?
      fail! 'This email has already registered, please login directly.' unless User.find_by_email(@email).nil?
    end

    def validate_password!
      fail! 'Password can not be blank.' if @password.blank?
      fail! 'Password is too short (minimum is 6 characters)' if @password.length < 6
    end

    def build_user
      user_props = {
          email: @email,
          password: @password,
          phone: @phone_number,
          first_name: @first_name,
          last_name: @last_name,
          type: @role.capitalize,
      }
      @user = User.create!(user_props)
      @message = 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    end
  end
end
