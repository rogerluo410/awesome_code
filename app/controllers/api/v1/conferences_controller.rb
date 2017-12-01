module Api
  module V1
    class ConferencesController < ApiBaseController
      before_action :authenticate!, only: [:token, :can_start_call, :decline_call]
      before_action :authenticate_doctor!, only: [:create, :update, :notify]

      def token
        token = current_user.generate_video_token
        render json: {data: {token: token.to_jwt}}
      end

      def create
        service = Conferences::Create.call(current_user, params[:appointment_id])
        if service.success?
          render json: {data: {conference_id: service.conference.id, patient: Api::V1::SessionUserSerializer.new(service.appointment.patient).as_json}}
        else
          render_api_error status: 422, message: service.error
        end
      end

      def update
        service = Conferences::Update.call(params[:id], update_params)
        if service.success?
          render status: 200, json: {message: :success}
        else
          render_api_error status: 422, message: service.error
        end
      end

      def notify
        service = Conferences::Notify.call(current_user, notify_params)
        if service.success?
          render status: 200, json: {message: :success}
        else
          render_api_error status: 422, message: service.error
        end
      end

      def decline_call
        service = Conferences::DeclineCall.call(current_user, params[:appointment_id])
        if service.success?
          render status: 200, json: {message: :success}
        else
          render_api_error status: 422, message: service.error
        end
      end

      def can_start_call
        service = Conferences::Validation.call(current_user, params[:appointment_id])
        if service.success?
          render status: 200, json: {message: :success}
        else
          render_api_error status: 422, message: service.error
        end
      end

      private
      def update_params
        params.require(:data).permit(:update_type, :status, :twilio_id, :time_type)
      end

      def notify_params
        params.require(:data).permit(:appointment_id)
      end
    end
  end
end
