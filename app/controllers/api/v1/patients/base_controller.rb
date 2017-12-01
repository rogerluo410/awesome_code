module Api
  module V1
    module Patients
      class BaseController < ApiBaseController
        before_action :authenticate_patient!

        private

        def authenticate_patient!
          authenticate!
          raise NotAuthorizedError, "User must be a patient" unless current_user.is_a?(Patient)
        end

      end
    end
  end
end
