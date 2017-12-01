class Auth::WebLoginUser
  include Serviceable

  validates! :email, presence: true
  validates! :password, presence: true

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def call
    valid?

    resource = User.find_for_database_authentication({email: email})
    validate_valid(resource)

    resource
  end

  private
  attr_reader :email, :password

  def validate_valid(resource)
    fail! 'Email is invalid.' unless resource

    fail! 'Password is invalid.' unless resource.valid_password? password
  end
end
