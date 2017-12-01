class Api::V1::DevicesController < Api::V1::ApiBaseController
  before_action :authenticate!

  def create
    service = Devices::Register.(current_user, device_params)

    if service.success?
      head 204
    else
      render_api_error status: 422, message: service.error
    end
  end

  def destroy
    service = Devices::Unregister.(current_user, device_params)
    head 204
  end

  private

  def device_params
    params.permit(:platform, :token)
  end
end
