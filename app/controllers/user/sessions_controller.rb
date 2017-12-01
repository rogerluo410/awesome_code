class User::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: [:create]

  def create
    if request.format.json?
      sign_in_via_ajax
    else
      super
    end
  end

  def destroy
    super
    cookies.clear
    flash.clear
  end

  protected

  def login_params
    params.require(:data).permit(:email, :password)
  end

  def sign_in_via_ajax
    service = Auth::WebLoginUser.call(login_params)
    if service.success?
      render json: service.result, serializer: Api::V1::SessionUserSerializer, root: 'data'
    else
      render_api_error status: 401, message: service.error
    end
  end

  def render_api_error(status:, message:)
    error = {message: message}
    render status: status, json: {error: error}
  end
end
