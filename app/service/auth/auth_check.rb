module Auth
  class AuthCheck
    include Serviceable

    validate :validate_token!

    def initialize(arg)
      @token = AuthToken.find(arg)
      @user = @token.user
    end

    def call
      valid?
      expand_expired_time
      user
    end

    attr_accessor :role
    attr_reader :user, :token

    private
    def validate_token!
      if token.expired_at.nil? || token.expired_at  < Time.zone.now
        token.destroy!
        fail!  "Token is expired."
      end
    end

    def expand_expired_time
      if token.expired_at < Time.zone.now + 24.hour # less than one day.
        token.update(expired_at: token.expired_at + AuthToken::DEFAULT_EXPAND_THRESHOID.day)
      end
    end

  end
end
