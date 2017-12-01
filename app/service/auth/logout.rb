
module Auth
  class Logout
    include Serviceable

    validate :validate_auth_token

    def initialize(user, params)
      @user = user
      @auth_token = params[:auth_token]
    end

    def call
      valid?
      destroy_auth_token
    end

    attr_reader :user, :auth_token

    private
    def current_auth_token
      user.auth_tokens.find_by(id: auth_token)
    end

    def validate_auth_token
      fail! "#{auth_token} is not a valid auth token" if current_auth_token.blank?
    end

    def destroy_auth_token
      current_auth_token.destroy
    end
  end
end
