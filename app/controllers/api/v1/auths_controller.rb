class Api::V1::AuthsController < Api::V1::ApiBaseController
  before_action :authenticate!, only: [:logout]

  def login
    service = Auth::LoginUser.call(login_params)

    if service.success?
      @auth_token = service.result.id
      @user = service.user

      render json: @user, serializer: Api::V1::AuthUserSerializer, root: 'data', auth_token: @auth_token
    else
      render_api_error status: 422, message: service.error
    end
  end

  def logout
    service = Auth::Logout.call(current_user, logout_params)

    if service.success?
      head 204
    else
      render_api_error status: 422, message: service.error
    end
  end

  def register
    service = Auth::RegisterUser.call(register_params)

    unless service.success?
      return render_api_error status: 422, message: service.error
    end

    auth_handle(service.patient)
  end

  def sign_up
    service = Auth::Signup.call(signup_params)
    if service.success?
      render status: 200, json: {message: service.message}
    else
      render_api_error status: 422, message: service.error
    end
  end

  def check
    service = Auth::AuthCheck.call(params[:token])
    if service.success?
      render json: service.result, serializer: Api::V1::AuthUserSerializer, root: 'data', auth_token: params[:token]
    else
      render_api_error status: 401, message: service.error
    end
  end

  private

  def login_params
    params.require(:data).permit(:role, :email, :password)
  end

  def register_params
    params.require(:data).permit(:email)
  end

  def signup_params
    params.require(:data).permit(:role, :email, :password, :phone_number, :first_name, :last_name)
  end

  def logout_params
    params.require(:data).permit(:auth_token)
  end

  def auth_handle(patient)
    if session_auth?
      sign_in(patient)
      render json: patient, serializer: Api::V1::SessionUserSerializer, root: 'data'
    else
      auth_token = patient.generate_auth_token
      render json: patient, serializer: Api::V1::AuthUserSerializer, root: 'data', auth_token: auth_token
    end
  end
end
