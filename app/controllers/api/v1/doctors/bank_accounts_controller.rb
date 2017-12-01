module Api
  module V1
    module Doctors
      class BankAccountsController < BaseController

        def create
          service = BankAccounts::Create.(current_user, bank_account_params)

          if service.success?
            render_one_jsonapi service.result, serializer: serializer
          else
            render_api_error status: 422, message: service.error
          end
        end

        def destroy
          service = BankAccounts::Destroy.(current_user)
          if service.success?
            render status: 200, json: { data: service.result }
          else
            render_api_error status: 422, message: service.error
          end
        end

        def show
          render_one_jsonapi current_user.bank_account, serializer: serializer
        end

        private

        def bank_account_params
          params.permit(:number, :country, :currency)
        end

        def serializer
          ::Api::V1::BankAccountSerializer
        end

      end
    end
  end
end
