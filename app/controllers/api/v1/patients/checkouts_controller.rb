module Api
  module V1
    module Patients
      class CheckoutsController < BaseController
        def index
          checkouts = current_user.checkouts.order(created_at: :desc)
          render_list checkouts, each_serializer: serializer
        end

        def create
          service = Checkouts::Create.(current_user, params)

          if service.success?
            render_one service.result, status: 201, serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        def destroy
          checkout = current_user.checkouts.find(params[:id])
          service = Checkouts::Delete.(checkout)

          if service.success?
            head 204
          else
            render_api_error status: 422, message: service.error
          end
        end

        def set_default
          checkout = current_user.checkouts.find(params[:id])

          unless checkout.default?
            current_user.checkouts.defaults.update_all(default: false)
            checkout.update!(default: true)
          end

          render_one checkout, serializer: serializer
        end

        private

        def serializer
          CheckoutSerializer
        end
      end
    end
  end
end
