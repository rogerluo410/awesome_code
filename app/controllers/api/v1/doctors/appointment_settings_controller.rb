module Api
  module V1
    module Doctors
      class AppointmentSettingsController < BaseController
        def index
          service = AppointmentSettings::FetchAll.call(current_user)

          if service.success?
            render status: 200, json: { data: service.result }
          else
            render_api_error status: 422, message: service.error
          end
        end

        def update
          service = AppointmentSettings::Update.call(current_user, settings_params)

          if service.success?
            render status: 200, json: { data: service.result }
          else
            render_api_error status: 422, message: service.error
          end
        end

        private

        def settings_params
          params.require(:data).permit(:id, periods: [:start_time, :end_time])
        end
      end
    end
  end
end
