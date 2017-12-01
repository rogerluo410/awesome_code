 module Api
  module V1
    module Doctors
      class ProfilesController < BaseController
        before_action :build_nested_object, only: [:show]

        def show
          render_one_jsonapi current_user,
            serializer: serializer,
            include: ['doctor_profile', 'address']
        end

        def update
          if current_user.update_attributes(doctor_params)
            render_one_jsonapi current_user, serializer: serializer, include: ['doctor_profile', 'address']
          else
            render_api_error status: 422, message: current_user.errors.full_messages.join(" , ")
          end
        end

        private
        def doctor_params
          params.require(:data).permit(
            :email, :username, :phone, :first_name, :last_name, :notify_email, :notify_system, :notify_sms, :local_timezone,
            doctor_profile_attributes: [
              :id, :years_experience, :bio_info, :specialty_id
            ],
            address_attributes: [
              :id, :postcode, :state, :suburb, :street_address
            ]
          )
        end

        def build_nested_object
          current_user.build_address if current_user.address.blank?
          current_user.build_doctor_profile if current_user.doctor_profile.blank?
          current_user.save
        end

        def serializer
          ::Api::V1::DocProfileSerializer
        end
      end
    end
  end
end
