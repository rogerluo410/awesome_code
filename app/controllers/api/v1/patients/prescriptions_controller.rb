module Api
  module V1
    module Patients
      class PrescriptionsController < BaseController

        def deliver
          service = Prescriptions::Update.(current_user, prescription_params)

          if service.success?
            render_list_jsonapi service.result, each_serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        private

        def prescription_params
          params.permit(:appointment_id, :pharmacy_id)
        end

        def serializer
          ::Api::V1::PrescriptionSerializer
        end

      end
    end
  end
end
