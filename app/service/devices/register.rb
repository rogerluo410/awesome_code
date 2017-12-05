module Devices
  class Register
    include Serviceable

    validates! :platform, inclusion: { in: Device.platforms.keys, message: "is invalid" }
    validates! :token, presence: true

    def initialize(user, params)
      @user = user
      @platform = params[:platform]
      @token = params[:token]
    end

    def call
      valid?
      register_device
    end

    attr_reader :user, :params, :token, :platform

    private

    def register_device
      device = Device.get_by_platform_and_token(platform, token)
      if device
        device.update!(user: user)
      else
        device = Device.create!(
          user: user,
          platform: platform,
          token: token,
        )
      end
      device
    end
  end
end
