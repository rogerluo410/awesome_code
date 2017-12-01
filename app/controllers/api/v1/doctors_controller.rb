module Api
  module V1
    class DoctorsController < ApiBaseController
      def index
        service = SearchDoctorsValidParams.call(search_params)

        if service.success?
          render json: SearchDoctors.call(service.result).doctor_results
        else
          render_api_error status: 422, message: service.error
        end
      end

      def profile
        doctor = Doctor.find(params[:id])
        render json: doctor, serializer: Api::V1::DoctorSerializer, root: 'data'
      end

      def appointment_periods
        service = AppointmentPeriods::BuildDailyPeriods.call(period_params)
        if service.success?
          render json: {data: service.result}
        else
          render_api_error status: 422, message: service.error
        end
      end

      private

      def search_params
        attrs = params.permit(:date, :from, :to, :specialty_id, :page, :tz, :q)
        attrs[:tz] = current_user.local_timezone if current_user.present?
        attrs
      end

      def period_params
        client_params = params.permit(:id, :date, :timezone)
        client_params[:timezone] = current_user.local_timezone if current_user.present?
        client_params
      end
    end
  end
end
