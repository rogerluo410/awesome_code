module Api
  module V1
    module Doctors
      class MedicalCertificatesController < BaseController
        def show
          @appointment = current_user.appointments.find(params[:appointment_id])

          medical_certificate = @appointment.medical_certificate

          render_one_jsonapi medical_certificate, serializer: serializer
        end

        def create
          @appointment = current_user.appointments.find(params[:appointment_id])
          @medical_certificate = @appointment.build_medical_certificate(params_medical_certificate)
          begin
            if @medical_certificate.save
              render_one_jsonapi @medical_certificate, serializer: serializer
            else
              render_api_error status: 422, message: @medical_certificate.errors.full_messages[0]
            end
          rescue Excon::Error => ex
            Rails.logger.error ex.response
            render_api_error status: 422, message: 'Failed to upload file'
          end
        end

        def destroy
          @appointment = current_user.appointments.find(params[:appointment_id])
          @medical_certificate = @appointment.medical_certificate

          if @medical_certificate.destroy
            head 204
          else
            render_api_error status: 422, message: @medical_certificate.erros.full_messages[0]
          end
        end

        private
        def params_medical_certificate
          params.permit(:file)
        end

        def serializer
          Api::V1::MedicalCertificateSerializer
        end
      end
    end
  end
end
