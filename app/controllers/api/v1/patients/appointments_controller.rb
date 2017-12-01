module Api
  module V1
    module Patients
      class AppointmentsController < BaseController

        def show
          appointment = ::Appointment.get_by_patient_and_id(current_user, params[:id])

          render_one_jsonapi appointment,
            serializer: Api::V1::PatAppointmentSerializer,
            include: ['comments', 'prescriptions', 'medical_certificate']
        end

        def active
          appointment = Appointment.get_by_patient_active(current_user)
          render_one appointment, serializer: serializer
        end

        def finished
          appointments = Appointment.get_list_by_patient_finished(
            current_user,
            page: params[:page],
            limit: params[:limit],
          )
          render_paginated_list appointments, each_serializer: serializer
        end

        def create
          service = ::Appointments::Create.call(current_user, params)

          if service.success?
            render status: 201, json: { survey_id: service.survey.id }
          else
            render_api_error status: 422, message: service.error
          end
        end

        def pay
          service = ::Payments::CreatePayment.call(current_user, pay_params)

          if service.success?
            render_one service.result, serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        def transfer
          service = ::AppointmentTransfers::CreateTransferNow.call(current_user, transfer_params)

          if service.success?
            render status: 201, json: { data: 'success' }
          else
            render_api_error status: 422, message: service.error
          end
        end

        def refund
          service = ::RefundRequests::CreateRefundRequest.call(current_user, transfer_params)

          if service.success?
            render status: 201, json: { data: 'success' }
          else
            render_api_error status: 422, message: service.error
          end
        end

        private

        def create_appointment_params
          params.permit(:appointment_setting_id, :start_time, :end_time, :doctor_id)
        end

        def pay_params
          permitted = params.require(:data).permit(:checkout_id)
          permitted[:appointment_id] = params[:id]
          permitted
        end

        def transfer_params
          {appointment_id: params[:id]}
        end

        def serializer
          AppointmentSerializer
        end

      end
    end
  end
end
