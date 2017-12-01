module Api
  module V1
    module Doctors
      class AppointmentProductsController < BaseController

        def scheduled
          appointment_products = ::AppointmentProduct.get_doctor_scheduled(current_user)

          render_list_jsonapi appointment_products,
            each_serializer: serializer,
            include: 'scheduled_appointments'
        end

        private

        def serializer
          ::Api::V1::AppointmentProductSerializer
        end

      end
    end
  end
end
