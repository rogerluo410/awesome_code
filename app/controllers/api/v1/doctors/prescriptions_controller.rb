module Api
  module V1
    module Doctors
      class PrescriptionsController < BaseController
        def index
          @appointment = current_user.appointments.find(params[:appointment_id])

          prescriptions = @appointment.prescriptions.try(:not_deleted)

          render_list_jsonapi prescriptions, each_serializer: serializer
        end

        def create
          service = Prescriptions::Create.(current_user, prescription_params)

          if service.success?
            render_one_jsonapi service.result, status: 201, serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        def destroy
          @appointment = current_user.appointments.find(params[:appointment_id])
          @prescription = @appointment.prescriptions.find(params[:id])

          @prescription.update!(deleted: true)

          render_one_jsonapi @prescription, serializer: serializer
        end

        private

        def prescription_params
          params.permit(:appointment_id, :file)
        end

        def serializer
          ::Api::V1::PrescriptionSerializer
        end

      end
    end
  end
end
