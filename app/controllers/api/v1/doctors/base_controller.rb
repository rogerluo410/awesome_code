module Api
  module V1
    module Doctors
      class BaseController < ApiBaseController
        before_action :authenticate_doctor!

        private

        def authenticate_doctor!
          authenticate!
          raise NotAuthorizedError, "User must be a doctor" unless current_user.is_a?(Doctor)
        end
      end
    end
  end
end
