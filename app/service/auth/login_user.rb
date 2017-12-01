module Auth
  class LoginUser
    include Serviceable

    attr_reader :user

    validate :validate_email!
    validate :validate_password!
    validate :validate_confirmed!
    validate :validate_role!

    def initialize(params)
      @email = params[:email]
      @password = params[:password]
      @role = params[:role]
    end

    def call
      valid?
      user.auth_tokens.create
    end

    attr_reader :user

    private
    def validate_email!
      fail! 'Email can not be blank.' if @email.blank?
      @user = User.find_by(email: @email)
      fail! "Can not find user with email #{@email}." if user.nil?
    end

    def validate_password!
      fail! 'Password can not be blank.' if @password.blank?
      fail! 'Invalid email or password.' unless user && user.valid_password?(@password)
    end

    def validate_confirmed!
      fail! 'You have to confirm your email address before continuing.' unless @user.confirmed?
    end

    def validate_role!
      fail! 'User role can not be blank.' if @role.blank?
      fail! "Role #{@role.downcase} is invalid." unless ['Patient'.downcase, 'Doctor'.downcase].include?(@role.downcase)
      fail! "Please sign in as a #{@user.class.name.downcase}." unless @user.class.name.downcase == @role.downcase
    end
  end
end
