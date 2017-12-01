class Api::V1::UsersController < Api::V1::ApiBaseController
  before_action :authenticate!, only: [:show, :upload_avatar]

  def show
    render json: current_user, serializer: Api::V1::SessionUserSerializer, root: 'data'
  end

  def profile
    user = User.find(params[:id])
    render json: user, serializer: Api::V1::SessionUserSerializer, root: 'data'
  end

  def upload_avatar
    image = current_user.decode_base64_image(params[:image][:uri])
    if image && current_user.update(image: image)
      image.close
      render_one_jsonapi current_user, serializer: serializer
    else
      render_api_error status: 422, message: "Failed to upload image. Please try after some time."
    end
  end

  def serializer
    if current_user.type == 'Doctor'
      ::Api::V1::DocProfileSerializer
    else
      ::Api::V1::PatProfileSerializer
    end
  end
end
