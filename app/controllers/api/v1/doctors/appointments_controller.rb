module Api
  module V1
    module Doctors
      class AppointmentsController < BaseController

        before_action :find_appointment, only: [:show, :approve, :decline]

        def show
          render_one_jsonapi @appointment,
            serializer: serializer,
            include: ['survey', 'comments', 'prescriptions', 'medical_certificate']
        end

        def upcoming
          appointment = ::Appointment.get_doctor_upcoming(current_user)

          render_one_jsonapi appointment,
            serializer: serializer,
            include: 'survey'
        end

        def finished
          appointments = ::Appointment.get_doctor_finished(
            current_user,
            page: params[:page],
            limit: params[:limit])

          # FIXME mobile app needs to use the REST API but it breaks doctor workspace on web app.
          # I use a params as workaround but it need to be fixed.
          if params[:use_rest]
            render_paginated_list appointments, each_serializer: serializer
          else
            render_list_jsonapi appointments, each_serializer: serializer
          end
        end

        def approve
          service = ::UpdateAppointmentStatus.call(@appointment, :accepted)
          if service.success?
            render_one_jsonapi @appointment, serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        def decline
          service = ::UpdateAppointmentStatus.call(@appointment, :decline)
          if service.success?
            render_one_jsonapi @appointment, serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        private

        def serializer
          ::Api::V1::DocAppointmentSerializer
        end

        def find_appointment
          @appointment = ::Appointment.get_by_doctor_and_id(current_user, params[:id])
        end

      end
    end
  end
end
