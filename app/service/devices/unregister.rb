module Devices
  class Unregister
    # include Serviceable

    def initialize(user, params)
      @user = user
      @platform = params[:platform]
      @token = params[:token]
    end

    def call
      return if platform.blank? || token.blank?
      Device.platform_and_token(platform, token).delete_all
    end

    private

    attr_reader :user, :platform, :token
  end
end
