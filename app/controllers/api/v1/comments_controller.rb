class Api::V1::CommentsController <  Api::V1::ApiBaseController
  before_action :authenticate!

  def index
    comments = Comment.get_list_by_appointment(params[:appointment_id], current_user)


    render_list_jsonapi comments, each_serializer: serializer
  end

  def create
    service = Comments::Create.call(current_user, comment_params)

    if service.success?
      render_one_jsonapi service.result, serializer: serializer, include: ['appointment']
    else
      render_api_error status: 422, message: service.error
    end
  end

  private
  def comment_params
    params.permit(:appointment_id, :body)
  end

  def serializer
    Api::V1::CommentSerializer
  end
end
